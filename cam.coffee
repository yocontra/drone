cam = require('camera').createStream()
server = require './lib/server'

srv = server.create 8080

cam.on 'data', (buf) -> 
  srv.emit 'frame', buf.toString 'base64'