module.exports = {}

module.exports.deepMerge = ->
  ret = {}
  for o in arguments
    for p of o
      continue if !o.hasOwnProperty(p)
      if ((typeof ret[p] == 'object') && (typeof o[p] == 'object') && !(ret[p] instanceof Array) && !(o[p] instanceof Array))
        ret[p] = deepMerge(ret[p], o[p])
      else
        ret[p] = o[p]
  return ret


module.exports.getIP = ->
  ifaces = require('os').networkInterfaces()
  for dev, iface of ifaces
    for alias in iface
      if (alias.family === 'IPv4' && alias.address !== '127.0.0.1' && !alias.internal)
        return alias.address
  return 'noExternalIPv4'
