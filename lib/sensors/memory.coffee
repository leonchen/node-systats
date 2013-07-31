Base = require './base'
os = require 'os'

class Memory extends Base
  constructor: (config) ->
    super(config)

    @_totalmem = os.totalmem()
    @_memUsage = null

  getData: (cb) ->
    t = Date.now()
    @_memUsage = [t, (@_totalmem - os.freemem())*100/@_totalmem]
    cb()

  result: ->
    total: @_totalmem,
    usage: @_memUsage

module.exports = Memory
