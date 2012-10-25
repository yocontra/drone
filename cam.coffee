cv = require 'opencv'
util = require './lib/util'
server = require './lib/server'

cam = new cv.VideoCapture 0

srv = server.create 8080

getImage = ->
  cam.read (im) ->
    buf = im.toBuffer()
    srv.emit 'frame', buf.toString 'base64'
    ###
    util.process buf, (err, can, orig) ->
      return console.log err if err?
      can.toBuffer (err, buff) ->
        return console.log err if err?
        srv.publish buff.toString 'base64'
    ###
    process.nextTick getImage
    #setTimeout getImage, 10

getImage()