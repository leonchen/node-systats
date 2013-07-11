server = "http://127.0.0.1:2470"
commitPath = "/commit"
os = require "os"
request = require 'request'
lsof = require './lsof'


lsof.countPID(process.pid)
lsof.countCommand('postgres')
lsof.run()

class Client
  constructor: (options) ->
    @commit()

  commit: ->
    options =
      uri: server + commitPath
      method: 'POST'
      qs:
        load: os.loadavg()
        sockets:
          sys: lsof.getSysCount()
          process: lsof.getCountByPID(process.pid)
          postgres: lsof.getCountByCommand('postgres')

    request options, =>
    setTimeout =>
      @commit()
    , 5000

  getStatus: ->
    return os.loadavg()

  

module.exports = Client
