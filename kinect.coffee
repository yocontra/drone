kinect = require 'kinect'
server = require './lib/server'
util = require './lib/util'
{Png} = require 'png'

srv = server.create 8080

cam = kinect.createStream 'video', '640x480', 60

cam.on 'data', (buf) ->
  png = new Png buf, 640, 480, 'rgb'
  png.encode (nbuf) ->
    uri = util.bufToUri nbuf
    srv.emit 'frame', uri

last = true
tilt = ->
  if last
    kinect.tilt 10
  else
    kinect.tilt -10
  last = !last
  setTimeout tilt, 5000

tilt()