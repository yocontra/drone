{Image} = Canvas = require 'canvas'

module.exports = util =
  findCenter: (coordinate) ->
    centerX = 320
    centerY = 184
    matchCenterX = coordinate.x + (coordinate.width / 2)
    x: matchCenterX
    y: coordinate.y + (coordinate.height / 2)
    xDist: Math.abs(centerX - matchCenterX)

  rgbToCanvas: (w, h, buf) ->
    can = new Canvas w, h
    ctx = can.getContext '2d'
    d = ctx.createImageData buf
    ctx.putImageData d, 0, 0
    return can

  bufToCanvas: (buf) ->
    img = new Image
    img.dataMode = Image.MODE_IMAGE
    img.src = buf
    can = new Canvas img.width, img.height
    ctx = can.getContext '2d'
    ctx.drawImage img, 0, 0, img.width, img.height
    return can

  bufToUri: (buf, fmt='png') ->
    "data:image/#{fmt};base64,#{buf.toString('base64')}"