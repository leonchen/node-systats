module.exports =
  process:
    cpu: require './process/cpu'
    memory: require './process/memory'
    socket: require './process/socket'
  system:
    cpu: require './cpu'
    load: require './load'
    memory: require './memory'
    socket: require './socket'
