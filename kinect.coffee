kinect = require 'kinect'
server = require './lib/server'
util = require './lib/util'
Png = require 'png-sync'

srv = server.create 8080

cam = kinect.createStream 'video', '640x480', 3

cam.on 'data', (buf) ->
  png = new Png.DynamicPngStack 'rgb'
  png.push buf
  uri = util.bufToUri png.encodeSync()
  srv.emit 'frame', uri