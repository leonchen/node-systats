Machine = require '../models/machine'
redis = require("redis").createClient()

class Client
  constructor: (options) ->
    @started = false
    @timeoutId = null
    @machine = null
    @loadMachine(options)

  loadMachine: (config) ->
    @machine = new Machine
      apps:
        redis:
          sensors:
            cpu:
              interval: 1000
            memory:
              interval: 1000
            socket:
              interval: 1000
        node:
          sensors:
            cpu:
              interval: 1000
            memory:
              interval: 1000
            socket:
              interval: 1000




  commit: ->
    result = {}
    now = Date.now()
    data = @machine.status()
    console.log(data)
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
