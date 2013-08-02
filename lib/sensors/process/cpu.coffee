Base = require "../base"
usage = require 'usage'

class CPU extends Base
  constructor: (config) ->
    super(config)

    @pid = config.pid
    @usage = null

  getData: (cb) ->
    usage.lookup @pid, { keepHistory: true }, (err, res) =>
      @usage = if err then null else res.cpu
      cb()

  result: ->
    return [Date.now(),  @usage]
     

module.exports = CPU
