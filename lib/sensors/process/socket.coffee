Base = require "../base"
lsof = require "../../lsof"

class Socket extends Base
  constructor: (config) ->
    super(config)

    @pid = config.pid
    lsof.countPID(@pid)
    lsof.start()

  getData: ->

  result: ->
    return [Date.now(), lsof.getCountByPID(@pid)]


module.exports = Socket
