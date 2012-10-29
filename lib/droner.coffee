fs = require 'fs'
PaVEParser = require './PaVEParser'
keypress = require 'keypress'

module.exports = droner =
  augment: (client) ->
    client._tcpVideoStream = client._pngStream._tcpVideoStream
    client._rawVideoStream = client._tcpVideoStream.pipe new PaVEParser

    client.safeguard = ->
      client.disableEmergency()
      client.on 'error', -> client.resume()
      client.on 'navdata', ({droneState}) ->
        client.emit 'lowBattery' if droneState.lowBattery is 1
      return client

    client.record = (loc) ->
      client._rawVideoStream.pipe fs.createWriteStream loc, flags: 'r+'
      return client

    client.enableControls = (speed=1, dur=500) ->
      flying = false
      sched = (f) -> setTimeout f, dur
      controls =
        right: ->
          client.counterClockwise speed
          sched -> client.counterClockwise 0
        left: ->
          client.clockwise speed
          sched -> client.clockwise 0
        up: ->
          client.up speed
          sched -> client.up 0
        down: ->
          client.down speed
          sched -> client.down 0
        w: ->
          client.front speed
          sched -> client.front 0
        a: ->
          client.left speed
          sched -> client.left 0
        s: ->
          client.back speed
          sched -> client.back 0
        d: ->
          client.right speed
          sched -> client.right 0
        space: ->
          if flying is true
            client.land()
          else
            client.takeoff()
          flying = !flying
        x: -> client.stop()
        r: -> client.disableEmergency()
        "1": -> client.animate "flipAhead", 15
        "2": -> client.animate "flipLeft", 15

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

    return droner