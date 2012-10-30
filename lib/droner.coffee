fs = require 'fs'
PaVEParser = require './PaVEParser'
keypress = require 'keypress'
{EventEmitter} = require 'events'
util = require './util'

module.exports = droner =
  augment: (client) ->
    client.createPngStream() unless client._pngStream._tcpVideoStream
    client._tcpVideoStream = client._pngStream._tcpVideoStream
    client._rawVideoStream = client._tcpVideoStream.pipe new PaVEParser

    client.faces = new EventEmitter

    client.config 'general:navdata_demo', 'TRUE'
    client.lastAltitude = 0
    client.lastState = 'CTRL_LANDED'
    client.lastBattery = 100

    client.batteryLevel = (cb) ->
      client.once 'navdata', ({demo}) ->
        return client.batteryLevel cb unless demo
        cb null, demo.batteryPercentage

    client.events = ->

      return client

    client.safeguard = ->
      client.disableEmergency()
      return client

    client.record = (loc) ->
      client._rawVideoStream.pipe fs.createWriteStream loc, flags: 'a'
      return client

    client.enableControls = (speed=0.5, dur=250) ->
      flying = false
      controls =
        right: ->
          client.counterClockwise speed
          client.after dur, -> client.counterClockwise 0
        left: ->
          client.clockwise speed
          client.after dur, -> client.clockwise 0
        up: ->
          client.up speed
          client.after dur, -> client.up 0
        down: ->
          client.down speed
          client.after dur, -> client.down 0
        w: ->
          client.front speed
          client.after dur, -> client.front 0
        a: ->
          client.left speed
          client.after dur, -> client.left 0
        s: ->
          client.back speed
          client.after dur, -> client.back 0
        d: ->
          client.right speed
          client.after dur, -> client.right 0
        space: ->
          if flying
            client.land()
          else
            client.takeoff()
          flying = !flying
        x: -> client.stop()
        r: -> client.disableEmergency()
        "1": -> client.animate "flipAhead", 15
        "2": -> client.animate "flipLeft", 15
        z: ->
          client.takeoff()
          client.once 'hovering', ->
            client.clockwise speed
            #client.up speed
            client.after 3000, ->
              client.clockwise 0
              #client.up 0
              #client.down speed
              client.counterClockwise speed
              client.after 2000, ->
                client.counterClockwise 0
                #client.down 0
                client.land()



      keypress process.stdin
      process.stdin.on 'keypress', (_, k) ->
        return unless k
        return process.exit() if k.ctrl and k.name is 'c'
        controls[k.name]? k

      process.stdin.setRawMode true
      process.stdin.resume()

      console.log """

        Controls:
        w - forward
        a - left
        s - backward
        d - right

        arrow up - up
        arrow left - spin left
        arrow down - down
        arrow right - spin right

        <space> - land/takeoff
        x - hover
        r - disable emergency mode
        1/2 - flipAhead/flipLeft

      """

      return client


    drawFaces = (buf) ->
      util.process buf, (can, orig) ->
        can.toBuffer (e, buff) ->
          client.faces.emit 'data', buff

    client.enableFaceRecognition = -> 
      client._pngStream.on 'data', drawFaces

    client.disableFaceRecognition = -> 
      client._pngStream.removeListener 'data', drawFaces

    return client