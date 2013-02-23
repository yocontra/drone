cam = require('camera').createStream()
server = require './lib/server'
faces = require 'faces'

srv = server.create 8080

faceStream = faces.createStream
  draw:
    type: 'ellipse'

faceStream.on 'data', (buf) ->
  srv.emit 'frame', faces.toImageUrl buf, 'jpeg'

cam.pipe faceStream
