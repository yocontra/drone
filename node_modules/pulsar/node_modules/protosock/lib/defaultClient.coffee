def =
  options: {}
  start: ->

  inbound: (socket, msg, done) ->
    try
      done JSON.parse msg
    catch e
      @error socket, e

  outbound: (socket, msg, done) ->
    try
      done JSON.stringify msg
    catch e
      @error socket, e

  validate: (socket, msg, done) -> done true
  invalid: -> #(socket, msg) ->

  connect: -> #(socket) ->
  message: -> #(socket, msg) ->
  error: -> #(socket, err) ->
  close: -> #(socket, reason) ->

`// if node`
module.exports = def
return
`// end`

def.options =
  host: window.location.hostname
  port: (if window.location.port.length > 0 then parseInt window.location.port else 80)
  secure: (window.location.protocol is 'https:')
def.options.port = 443 if def.options.secure
module.exports = def
