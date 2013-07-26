Machine = require '../models/machine'
redis = require("redis").createClient()

class Client
  constructor: (options) ->
    @started = false
    @timeoutId = null
    @machine = new Machine(options)

  commit: ->
    result = {}
    now = Date.now()
    #data = @machine.status()
    result[@machine.name] = [now, @machine.status()]

    redis.publish "client.data", JSON.stringify result

    @timeoutId = setTimeout =>
      @commit()
    , 2000

  start: ->
    return if @started
    @started = true
    @machine.start()
    @commit()

  stop: ->
    return unless @started
    if @timeoutId
      clearTimeout @timeoutId
      @timeoutId = null
    @machine.stop()
    @started = false

  

module.exports = Client
