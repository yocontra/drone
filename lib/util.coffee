{Image} = Canvas = require 'canvas'

chunk = (arr, len) ->
  i = 0
  n = arr.length
  return (arr.slice(i, i += len) while i < n)

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

    d = ctx.createImageData w, h
    chunks = chunk buf, 3
    n = chunks.length
    i = 0
    while i < n
      d.data[i*4+0] = chunks[i][0] # r
      d.data[i*4+1] = chunks[i][1] # g
      d.data[i*4+2] = chunks[i][2] # b
      d.data[i*4+3] = 1 # a

      ++i

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