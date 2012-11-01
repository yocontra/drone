kinect = require 'kinect'
server = require './lib/server'
util = require './lib/util'
{Png} = require 'png-sync'

srv = server.create 8080

cam = kinect.createStream 'video', '640x480', 60

cam.on 'data', (buf) ->
  png = new Png buf, 640, 480, 'rgb'
  nbuf = png.encodeSync()
  uri = util.bufToUri nbuf
  srv.emit 'frame', uri

depth = kinect.createStream 'depth'

depth.on 'data', (buf) ->
