cam = require('camera').createStream()
cv = require 'opencv'

cam.on 'data', (buf) ->
  cv.readImage buf, (err, im) ->
    return console.log 'read', err if err?
    im.detectObject "./lib/haarcascade_frontalface_alt.xml", {}, (err, faces) ->
      return console.log 'detect', err if err?
      console.log faces  