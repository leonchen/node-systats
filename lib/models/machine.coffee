utils = require "../utils"

Application = require "./application"

class Machine
  constructor: (config) ->
    @name = config.name || utils.getIP()
    for app, config of (config.apps || {})
      @app[app] = new Application(app, config)

    @started = false

  start: ->
    return if @started
    for name, app of @apps
      app.start()
    @started = true

  stop: ->
    return unless @started
    for name, app of @apps
      app.stop()
    @started = false


module.exports = Machine
