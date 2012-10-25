cv = require 'opencv'
http = require 'http'
async = require 'async'
fs = require 'fs'
{Image} = Canvas = require 'canvas'
{join} = require 'path'

faceloc = join __dirname, "./haarcascade_frontalface_alt.xml"

drawEllipse = (ctx, x, y, w, h) ->
  kappa = .5522848
  ox = (w / 2) * kappa # control point offset horizontal
  oy = (h / 2) * kappa # control point offset vertical
  xe = x + w # x-end
  ye = y + h # y-end
  xm = x + w / 2 # x-middle
  ym = y + h / 2 # y-middle

  ctx.strokeStyle = 'rgba(255,0,0,1)'
  ctx.beginPath()
  ctx.moveTo x, ym
  ctx.bezierCurveTo x, ym - oy, xm - ox, y, xm, y
  ctx.bezierCurveTo xm + ox, y, xe, ym - oy, xe, ym
  ctx.bezierCurveTo xe, ym + oy, xm + ox, ye, xm, ye
  ctx.bezierCurveTo xm - ox, ye, x, ym + oy, x, ym
  ctx.closePath()
  ctx.stroke()

module.exports = util =
  process: (buf, cb) ->
    orig = util.bufToCanvas buf

    util.detectFaces buf, (err, faces) ->
      return console.log err if err?
      util.drawFaces buf, faces, (can) ->
        return cb null, can, orig

    return util

  saveCanvas: (can, path, cb) ->
    can.toBuffer (err, buf) ->
      return cb err if err?
      fs.writeFile path, buf, (err) ->
        return cb err if err?
        return cb()
    return util

  bufToCanvas: (buf) ->
    img = new Image
    img.src = buf
    can = new Canvas img.width, img.height
    ctx = can.getContext '2d'
    ctx.drawImage img, 0, 0, img.width, img.height
    return can

  drawFaces: (buf, faces, cb) ->
    can = util.bufToCanvas buf
    ctx = can.getContext '2d'

    draw = (f, done) ->
      drawEllipse ctx, f.x, f.y, f.width, f.height
      done()

    async.forEach faces, draw, -> cb can
    return util

  detectFaces: (buf, cb) ->
    cv.readImage buf, (err, im) ->
      return cb err if err?
      im.detectObject faceloc, {}, (err, faces) ->
        return cb err if err?
        return cb null, faces
    return util