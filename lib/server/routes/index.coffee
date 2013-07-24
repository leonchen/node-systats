live = require '../handlers/live'
history = require '../handlers/history'

module.exports.setup = (app) ->
  app.get '/live/*', (req, res) =>
    live.process(req, res)

  app.get '/history/*', (req, res) =>
    history.process(req, res)
