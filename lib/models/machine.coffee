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
    @loadSensors()

  loadApps: (apps) ->
    for app, config of (apps || {})
      @apps[app] = new Application(app, config)

  loadSensors: ->
    config =
      interval: 2000
    for name, sensor of systemSensors
      @sensors[name] = new sensor(config)

  status: ->
    result = {}
    for name, app of @apps
      result[name] = app.status()
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
