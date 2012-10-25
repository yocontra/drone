arDrone = require 'ar-drone'
util = require './lib/util'
server = require './lib/server'
controls = require './lib/hjkl'

drone = arDrone.createClient()
drone.disableEmergency()


## Stream video
srv = server.create 8080
video = drone.createPngStream log: process.stderr
video.on 'error', console.log
video.on 'data', (buf) ->
  srv.emit 'frame', buf.toString 'base64'
  ###
  util.process buf, (err, can, orig) ->
    return console.log err if err?
    lastPng = can.toBuffer()
  ###


controls.hook drone