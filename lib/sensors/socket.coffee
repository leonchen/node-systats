Base = require "./base"
lsof = require "../lsof"

class Socket extends Base
  constructor: (config) ->
    super(config)

    lsof.start()

  getData: ->

  result: ->
    return lsof.getSysCount()

module.exports = Socket
