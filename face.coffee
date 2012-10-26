arDrone = require 'ar-drone'
util = require './lib/util'
server = require './lib/server'
controls = require './lib/hjkl'
PaVEParser = require './lib/PaVEParser'

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
    can.toBuffer (err, buff) ->
      return console.log err if err?
      srv.emit 'frame', buff.toString 'base64'
###

## Record video
###
out = require('fs').createWriteStream './vid.h246', encoding: 'binary'

parser = new PaVEParser
video._tcpVideoStream.pipe(parser).pipe out
###

## Log navdata
logged = false
drone.on 'navdata', (d) -> 
  if d.droneState.lowBattery is 1 and !logged
    console.log 'LOW BATTERY'
    logged = true
  #srv.emit 'navdata', d

## Add keyboard controls
controls.hook drone