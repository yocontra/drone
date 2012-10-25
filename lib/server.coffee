express = require 'express'
Pulsar = require 'pulsar'
{join} = require 'path'
http = require 'http'

module.exports =
  create: (port) ->
    app = express()
    app.use express.static join __dirname, "../public"

    srv = http.createServer app
    pulse = Pulsar.createServer server: srv
    chan = pulse.channel 'main'
    srv.listen port

    return chan