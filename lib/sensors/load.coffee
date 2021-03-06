Base = require './base'
os = require 'os'

class Load extends Base
  constructor: (config) ->
    super(config)

    @_load = {}

  getData: (cb) ->
    t = Date.now()
    loadavg = os.loadavg()
    @_load =
      "1m": [t, loadavg[0]]
      "5m": [t, loadavg[1]]
      "15m": [t, loadavg[2]]
    cb()

  result: ->
    return @_load




module.exports = Load
