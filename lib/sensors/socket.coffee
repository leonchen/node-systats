Base = require "./base"
exec = require('child_process').exec

class Socket extends Base
  constructor: (config) ->
    super(config)

    @sockets = null

  getData: (cb) ->
    exec "lsof |wc -l", (err, stdout, stderr) =>
      @sockets = if err then null else parseInt(stdout)
      cb()

  result: ->
    total: [Date.now(), @sockets]

module.exports = Socket
