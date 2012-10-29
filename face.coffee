arDrone = require 'ar-drone'
util = require './lib/util'
server = require './lib/server'
droner = require './lib/droner'

drone = arDrone.createClient()

## Stream video
srv = server.create 8080
video = drone.createPngStream()
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


## Augment drone
droner.augment drone

drone.enableControls()
  # ffmpeg -i recording.h246 -vcodec copy recording.mp4
  .record('./recording.h246')
  .safeguard()
  .once 'lowBattery', ->
    console.log 'LOW BATTERY'