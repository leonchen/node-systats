class Base
  constructor: (config) ->
    @interval = config.interval
    @timeoutId = null
    @started = false

  start: ->
    return if @started
    @started = true
    @run()

  run: ->
    @getData =>
      @timeoutId = setTimeout =>
        @run()
      , @interval

  getData: (cb)->
    cb()

  result: ->
    return [Date.now(), null]

  stop: ->
    return unless @started
    if @timeoutId
      clearTimeout @timeoutId
      @timeoutId = null
    @started = false

module.exports = Base
