cv = require 'opencv'
util = require './util'
{join} = require 'path'
async = require 'async'

cascade = new cv.CascadeClassifier join __dirname, "./haarcascade_frontalface_alt.xml"

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

module.exports = faces =
  process: (buf, cb) ->
    faces.detect buf, (err, res) ->
      return cb err if err?
      faces.draw buf, res, (can) ->
        cb null, can, res

  detect: (buf, cb) ->
    cv.readImage buf, (err, im) ->
      return cb err if err?
      cascade.detectMultiScale im, cb

  draw: (buf, faces, cb) ->
    can = util.bufToCanvas buf
    ctx = can.getContext '2d'

    draw = (f, done) ->
      drawEllipse ctx, f.x*6, f.y*6, f.width*6, f.height*6
      done()

    async.forEach faces, draw, -> cb can