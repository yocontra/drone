face_detect = require 'face-detect'
http = require 'http'
async = require 'async'
fs = require 'fs'
{Image} = Canvas = require 'canvas'
{join} = require 'path'

faceloc = join __dirname, "./haarcascade_frontalface_alt.xml"

drawEllipse = (ctx, x, y, w, h) ->
  cx = x+w/2
  cy = y+h/2
  ctx.beginPath()
  ctx.moveTo cx, cy-h/2
  ctx.bezierCurveTo cx+w/2, cy-h/2, cx+w/2, cy+h/2, cx, cy+h/2
  ctx.bezierCurveTo cx-w/2, cy+h/2, cx-w/2, cy-h/2, cx, cy-h/2
  ctx.strokeStyle = 'rgba(255,0,0,1)'
  ctx.stroke()
  ctx.closePath()

module.exports = util =
  process: (buf, cb) ->
    thumb = util.bufToCanvas buf, 6
    faces = face_detect.detect_objects
      canvas: thumb
      interval: 1
      neighbors: 1
    util.drawFaces buf, faces, cb
    return util

  bufToCanvas: (buf, scale=1) ->
    img = new Image
    img.dataMode = Image.MODE_IMAGE
    img.src = buf
    can = new Canvas img.width/scale, img.height/scale
    ctx = can.getContext '2d'
    ctx.drawImage img, 0, 0, img.width/scale, img.height/scale
    return can

  bufToUri: (buf) ->
    "data:image/png;base64,#{buf.toString('base64')}"

  drawFaces: (buf, faces, cb) ->
    can = util.bufToCanvas buf
    ctx = can.getContext '2d'

    draw = (f, done) ->
      drawEllipse ctx, f.x*6, f.y*6, f.width*6, f.height*6
      done()

    async.forEach faces, draw, -> cb can
    return util