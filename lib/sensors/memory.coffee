Base = require './base'

class Memory extends Base
  constructor: (config) ->
    super(config)

    @_totalmem = os.totalmem()
    @_memUsage = null

  getData: ->
    t = Date.now()
    @_memUsage = [t, (@_totalmem - os.freemem())*100/@_totalmem]

  result: ->
    return @_memUsage

module.exports = Memory
