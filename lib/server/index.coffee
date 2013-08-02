express = require 'express'
http = require 'http'
path = require 'path'

redis = require("redis").createClient()

routes = require './routes'
$data = {}

class Server
  constructor: ->
    @initServer()

  initServer: ->
    app = express()

    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router
    app.use express.static(path.join(__dirname, 'public'))

    app.post '/commit', (req, res) =>
      $data = req.body
      res.send 200

    redis.on "message", (channel, message) =>
      data = JSON.parse message
      machine = Object.keys(data)[0]
      $data[machine] = data[machine]
    redis.subscribe "client.data"

    app.get '/', (req, res) =>
      res.render 'index', {machines: $data}

    app.get '/status/:machineId', (req, res) =>
      res.set "Access-Control-Allow-Origin", "*"
      if $data[req.params.machineId]
        res.json $data[req.params.machineId][1] 
      else
        res.json {}

    app.get '/machine/:machineId', (req, res) =>
      m = req.params.machineId
      res.render 'machine', {machine:m}

    routes.setup app

    http.createServer(app).listen 2470


module.exports = Server
