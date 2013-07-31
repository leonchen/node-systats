Base = require "../base"
usage = require 'usage'

class Memory extends Base
  constructor: (config) ->
    super(config)

    @pid = config.pid
    @usage = null

  getData: (cb) ->
    usage.lookup @pid, (err, res) =>
      @usage = if err then null else res.memory
      cb()

  result: ->
    return [Date.now(), @usage]

module.exports = Memory
