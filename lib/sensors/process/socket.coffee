Base = require "../base"
exec = require('child_process').exec

class Socket extends Base
  constructor: (config) ->
    super(config)

    @pid = config.pid
    @sockets = null

  getData: (cb) ->
    exec "ls -l /proc/#{@pid}/fd |wc -l", (err, stdout, stderr) =>
      @sockets = if err then null else parseInt(stdout)
      cb()


  result: ->
    return [Date.now(), @sockets]


module.exports = Socket
