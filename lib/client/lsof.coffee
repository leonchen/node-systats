exec = require('child_process').exec

FIELDS =
  command: 0
  pid: 1
  user: 2
  fd: 3
  type: 4
  device: 5
  size: 6
  node: 7
  name: 8

FIELD_MATCH = (name, data) ->
  field = FIELDS[name]
  value = JSON.stringify(data)
  return " |awk '$"+field+" == "+value+"'"

class LSOF
  constructor: ->
    @commands = {}
    @result = {}
    @started = false

  start: ->
    return if @started
    @started = true
    @run()

  run: ->
    exec 'lsof -i', (err, stdout, stderr) =>
      @result = {'sys': -1}
      for line in stdout.split(/[\r\n]+/)
        @result['sys'] += 1
        row = line.split(/\s+/)
        for f, vals of @commands
          @result[f] ?= {}
          idx = FIELDS[f]
          for val of vals
            @result[f][val] ?= 0
            @result[f][val] += 1 if val == row[idx]

    setTimeout =>
      @run()
    , 5000

  countPID: (pid) ->
    @addCommand('pid', pid)

  countCommand: (name) ->
    @addCommand('command', name)

  addCommand: (field, value) ->
    @commands[field] ?= {}
    @commands[field][value.toString()] = true

  getSysCount: ->
    return @result['sys']

  getCountByPID: (pid) ->
    @result['pid'] ?= {}
    return @result['pid'][pid.toString()]

  getCountByCommand: (name) ->
    @result['command'] ?= {}
    return @result['command'][name]

module.exports = new LSOF()
