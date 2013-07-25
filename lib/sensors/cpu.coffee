Base = require './base'
os = require 'os'

class CPU extends Base
  constructor: (config) ->
    super(config)

    @cpus = os.cpus()
    @_cpuUsage = {}

  getData: ->
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

  result: ->
    return @_cpuUsage

module.exports = CPU
