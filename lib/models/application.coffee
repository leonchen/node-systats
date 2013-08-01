exec = require('child_process').exec

Process = require './process'

class Application
  constructor: (name, config) ->
    @name = name
    @sensors = config.sensors
    @started = false

    @processes = {}
    @checkInterval = config.checkInterval || 5000
    @checkTimeoutId = null


  loadProcesses: (cb)->
    exec 'pidof '+@name, (err, stdout, stderr) =>
      stdout = "" if err
      pids = stdout.toString().split(/\s+/)
      running = {}
      for pid in pids
        if pid && !@processes[pid]
          p = new Process(parseInt(pid), @sensors)
          @processes[pid] = p
          p.start()
        running[pid] = true

      for pid, p of @processes
        unless running[pid]
          p.stop()
          delete @processes[pid]

      cb()

  status: ->
    t = Date.now()
    result = {}
    for pid, p of @processes
      r = p.status()
      for sensor, data of r
        result[sensor] ?= [t, 0]
        result[sensor][1] += data[1] if data[1]
      #result[pid] = p.status()
    return result

  start: ->
    return if @started
    @started = true
    @run()

  run: ->
    @loadProcesses =>
      @checkTimeoutId = setTimeout =>
        @run()
      , @checkInterval

  stop: ->
    #return unless @started
    if @checkTimeoutId
      clearTimeout(@checkTimeoutId)
      @checkTimeoutId = null
    for pid, p of @processes
      p.stop()
    @started = false

module.exports = Application
