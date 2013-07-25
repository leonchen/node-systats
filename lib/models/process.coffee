Sensors = require('../sensors').process

class Process
  constructor: (pid, sensors) ->
    @pid = pid
    @sensors = {}
    @started = false

    for name, config of sensors
      @initSensor(name, config)

  initSensor: (name, config) ->
    if Sensors[name]
      config.pid = @pid
      sensor = new Sensors[name](config)
      @sensors[name] = sensor
    else
      throw "unknown sensor: "+name

  status: ->
    result = {}
    for name, sensor of @sensors
      result[name] = sensor.result()
    return result

  start: ->
    return if @started
    for name, sensor of @sensors
      sensor.start()
    @started = true

  stop: ->
    return unless @started
    for name, sensor of @sensors
      sensor.stop()
    @started = false


module.exports = Process
