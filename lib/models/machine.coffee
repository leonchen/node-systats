utils = require "../utils"
systemSensors = require('../sensors').system

Application = require "./application"

class Machine
  constructor: (config) ->
    @name = config.name || utils.getIP()
    @apps = {}
    @sensors = {}
    @started = false


    @loadApps(config.apps)
    @loadSensors(config.system) if config.system

  loadApps: (apps) ->
    for app, config of (apps || {})
      @apps[app] = new Application(app, config)

  loadSensors: (sensors) ->
    config =
      interval: 2000
    for name, sensor of systemSensors
      @sensors[name] = new sensor(config) if sensors[name]

  status: ->
    result =
      apps: {}
    for name, app of @apps
      result.apps[name] = app.status()
    for n, sensor of @sensors
      result[n] = sensor.result()
    return result

  start: ->
    return if @started
    for name, app of @apps
      app.start()
    for n, sensor of @sensors
      sensor.start()
    @started = true

  stop: ->
    return unless @started
    for name, app of @apps
      app.stop()
    for n, sensor of @sensors
      sensor.stop()
    @started = false


module.exports = Machine
