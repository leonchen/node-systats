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
        unless @processes[pid]
          p = new Process(pid, @sensors)
          @processes[pid] = p
          p.start()
        running[pid] = true

      for pid in @processes
        unless running[pid]
          @processes[pid].stop()
          delete @processes[pid]

      cb()

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
