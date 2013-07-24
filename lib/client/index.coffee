server = "http://127.0.0.1:2470"
commitPath = "/commit"
request = require 'request'
system = require "./system"
lsof = require '../lsof'

redis = require("redis").createClient()

system.run()
lsof.countPID(process.pid)
lsof.countCommand('postgres')
lsof.start()



class Client
  constructor: (options) ->
    @commit()

  commit: ->
    now = Date.now()
    data =
      os:
        load: system.load()
        cpu: system.cpuUsage()
        memory:
          process: [now, process.memoryUsage()]
          usage: system.memUsage()
          total: system.totalmem()
      socks:
        sys: lsof.getSysCount()
        process: lsof.getCountByPID(process.pid)
        postgres: lsof.getCountByCommand('postgres')
      json: data

    redis.publish "client.data", JSON.stringify(data)
    setTimeout =>
      @commit()
    , 2000

  getStatus: ->
    return os.loadavg()

  

module.exports = Client
