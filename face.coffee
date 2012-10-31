arDrone = require 'ar-drone'
server = require './lib/server'
droner = require './lib/droner'
util = require './lib/util'

drone = arDrone.createClient()

## Augment drone
droner.augment(drone)
  .enableControls()
  #.record('./recording.h264') # ffmpeg -i recording.h264 -vcodec copy recording.mp4
  .events()
  .safeguard()
  #.enableFaceRecognition()


## Stream video
srv = server.create 8080
video = drone.createPngStream()
video.on 'data', (buf) ->
  util.process buf, (err, can, faces) ->
    return console.log err if err?
    can.toDataURL (err, uri) ->
      return console.log err if err?
      srv.emit 'frame', can.uri

drone.batteryLevel (err, level) ->
  return console.log err if err?
  console.log "Battery level - #{level}%"

drone.once 'lowBattery', (level) ->    
  console.log "LOW BATTERY - #{level}%"

drone.on 'landing', -> console.log 'landing'
drone.on 'takeoff', -> console.log 'takeoff'
drone.on 'hovering', -> console.log 'hovering'
drone.on 'flying', -> console.log 'flying'

#drone.faces.on 'data', (buf) -> 
#  srv.emit 'frame', util.bufToUri buf