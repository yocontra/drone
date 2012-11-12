kinect = require 'kinect'
server = require './lib/server'
util = require './lib/util'

{Png} = require 'png'

srv = server.create 8080

cam = kinect.createStream 'video', '640x480', 30

process = (buf) ->
  can = util.rgbToCanvas 640, 480, buf
  can.toDataURL (err, uri) ->
    return console.log err if err?
    srv.emit 'frame', uri

cam.on 'data', process

last = true
tilt = ->
  if last
    kinect.tilt 10
  else
    kinect.tilt -10
  last = !last
  setTimeout tilt, 5000

tilt()

kinect.led "green"
#depth = kinect.createStream 'depth'

#depth.on 'data', process