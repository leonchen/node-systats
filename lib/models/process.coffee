Sensors = require '../sensors'

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
      sensor = new Sensors.process[name](config)
      @sensors[name] = sensor
    else
      throw "unknown sensor: "+name


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
