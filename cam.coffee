cv = require 'opencv'
util = require './lib/util'
server = require './lib/server'

cam2 = new cv.VideoCapture 0
cam = new cv.VideoCapture 1

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

getImage2 = ->
  cam2.read (im) ->
    buf = im.toBuffer()
    srv.emit 'frame2', buf.toString 'base64'
    ###
    util.process buf, (err, can, orig) ->
      return console.log err if err?
      can.toBuffer (err, buff) ->
        return console.log err if err?
        srv.publish buff.toString 'base64'
    ###
    process.nextTick getImage2
    #setTimeout getImage2, 10

getImage2()