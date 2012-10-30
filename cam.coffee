cam = require('camera').createStream 1
server = require './lib/server'
util = require './lib/util'

srv = server.create 8080

cam.on 'data', (buf) ->
  #srv.emit 'frame', util.bufToUri buf
  util.process buf, (can, faces) ->
    console.log faces
    #can.toBuffer (err, buff) ->
    #  srv.emit 'frame', util.bufToUri buff