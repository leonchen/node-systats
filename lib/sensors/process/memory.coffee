Base = require "../base"
usage = require 'usage'
os = require 'os'

class Memory extends Base
  constructor: (config) ->
    super(config)

    @pid = config.pid
    @usage = null
    @multiplier = if os.platform() is 'darwin' then 1024 else 1

  getData: (cb) ->
    usage.lookup @pid, (err, res) =>
      @usage = if err then null else res.memory*@multiplier
      cb()

  result: ->
    return [Date.now(), @usage]

module.exports = Memory
