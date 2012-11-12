cv = require 'opencv'
util = require './util'
{join} = require 'path'
async = require 'async'

cascade = new cv.CascadeClassifier join __dirname, "./haarcascade_frontalface_alt.xml"

module.exports = faces =
  # in: png buffer, cb
  # out: cb(error, buffer, faces)
  process: (buf, cb) ->
    faces.detect buf, (err, res, im) ->
      return cb err if err?
      faces.draw im, res
      im.toBuffer (e, buff) -> cb e, buff, res
    return util

  # in: png buffer, cb
  # out: cb(error, faces, image)
  detect: (buf, cb) ->
    cv.readImage buf, (err, im) ->
      return cb err if err?
      done = (e, f) -> cb e, f, im
      cascade.detectMultiScale im, done, 2, 2, [30,30]
    return util

  # in: image, faces, cb
  # out: side effects on image
  draw: (im, faces, cb) ->
    color = [0,255,0]
    thickness = 2
    for f in faces
      im.rectangle [f.x,f.y], [f.x+f.width,f.y+f.height], color, thickness
    return im