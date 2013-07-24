Base = require './base'

class Load extends Base
  constructor: (config) ->
    super(config)

    @_load = {}

  getData: ->
    t = Date.now()
    loadavg = os.loadavg()
    @_load =
      "1m": [t, loadavg[0]]
      "5m": [t, loadavg[1]]
      "15m": [t, loadavg[2]]

  result: ->
    return @_load




module.exports = Load
