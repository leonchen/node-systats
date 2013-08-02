exec = require('child_process').exec

Process = require './process'
EXISTING_PERIOD = 2

class Application
  constructor: (name, config) ->
    @name = name
    @sensors = config.sensors
    @started = false

    @processes = {}
    @processesCache = {}
    @checkInterval = config.checkInterval || 5000
    @checkTimeoutId = null


  loadProcesses: (cb)->
    exec 'pidof '+@name, (err, stdout, stderr) =>
      stdout = "" if err
      pids = stdout.toString().split(/\s+/)
      running = {}
      for pid in pids
        if pid && @processesCache[pid] > EXISTING_PERIOD && !@processes[pid]
          p = new Process(parseInt(pid), @sensors)
          @processes[pid] = p
          p.start()
        running[pid] = true
        @processesCache[pid] ?= 1

      for pid, count of @processesCache
        if running[pid]
          @processesCache[pid] += 1
        else
          delete @processesCache[pid]

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
        result[sensor] ?=
          total: [t, 0]
        result[sensor].total[1] += data[1] if data[1]
        result[sensor][pid] = data
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
