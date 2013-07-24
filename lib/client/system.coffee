os = require 'os'

class System
  constructor: ->
    @cpus = os.cpus()
    @_cpuUsage = {}
    @_load = {}
    @_totalmem = os.totalmem()
    @_memUsage = null
    @started = false

  run: ->
    return if @started
    @started = true
    @_run()
  _run: ->
    t = Date.now()
    cpus = os.cpus()
    usage = 0
    for cpu, idx in cpus
      times = cpu.times
      history = @cpus[idx].times
      using = times.user - history.user + times.sys - history.sys
      total = using + times.idle - history.idle
      percentage = using *100/total
      usage += percentage
      @_cpuUsage["cpu"+(idx+1)] = [t, percentage]

    @_cpuUsage.avg = [t, usage/cpus.length]
    @cpus = cpus

    loadavg = os.loadavg()
    @_load =
      "1m": [t, loadavg[0]]
      "5m": [t, loadavg[1]]
      "15m": [t, loadavg[2]]
    
    @_memUsage = [t, (@_totalmem - os.freemem())*100/@_totalmem]

    setTimeout =>
      @_run()
    , 1000
  
  load: ->
    return @_load
  cpuUsage: ->
    return @_cpuUsage
  memUsage: ->
    return @_memUsage
  totalmem: ->
    return @_totalmem
 

module.exports = new System()
