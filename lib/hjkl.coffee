module.exports = 

  hook: (client) ->
    speed = 1
    flying = false
    redMode = false

    process.stdin.setRawMode true
    process.stdin.resume()

    process.stdin.on "data", (buf) ->
      if buf[0] is 3
        client.land()
        setTimeout (->
          process.exit()
        ), 250

      s = String.fromCharCode(buf[0])

      if s is "h"
        client.counterClockwise speed
        setTimeout (->
          client.counterClockwise 0
        ), 250
      else if s is "j"
        client.down speed
        setTimeout (->
          client.down 0
        ), 250
      else if s is "k"
        client.up speed
        setTimeout (->
          client.up 0
        ), 250
      else if s is "l"
        client.clockwise speed
        setTimeout (->
          client.clockwise 0
        ), 250
      else if s is "w"
        client.front speed
        setTimeout (->
          client.front 0
        ), 250
      else if s is "a"
        client.left speed
        setTimeout (->
          client.left 0
        ), 250
      else if s is "s"
        client.back speed
        setTimeout (->
          client.back 0
        ), 250
      else if s is "d"
        client.right speed
        setTimeout (->
          client.right 0
        ), 250
      else if s is " "
        if flying is true
          client.land()
        else
          client.takeoff()
        flying = !flying
      else if s is "x"
        client.stop()
      else if s is "r"
        client.disableEmergency()

      else if s is "1"
        client.animate "flipAhead", 15
      else if s is "2"
        client.animate "flipLeft", 15
      else if s is "3"
        client.animate "yawShake", 15
      else if s is "4"
        client.animate "doublePhiThetaMixed", 15
      else if s is "5"
        client.animate "wave", 15

    console.log "Controls:"
    console.log "w - forward"
    console.log "s - backward"
    console.log "h - left"
    console.log "j - down"
    console.log "k - up"
    console.log "l - right"
    console.log "<space> - land/takeoff toggle"
    console.log "x - stop"
    console.log "r - disable emergency mode"
    console.log "f - flipLeft"