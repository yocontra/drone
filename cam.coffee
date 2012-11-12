cam = require('camera').createStream 1
server = require './lib/server'
util = require './lib/util'
faces = require './lib/faces'

srv = server.create 8080

cam.on 'data', (buf) ->
  faces.process buf, (err, buff, faces) ->
    return console.log err if err?
    srv.emit 'frame', util.bufToUri buff, 'jpeg'