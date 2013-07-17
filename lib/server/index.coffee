express = require 'express'
http = require 'http'
path = require 'path'

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

    app.get '/', (req, res) =>
      res.render 'index', {data: $data}

    app.get '/usage', (req, res) =>
      res.set "Access-Control-Allow-Origin", "*"
      res.json $data

    app.get '/machine', (req, res) =>
      res.render 'machine', {data: $data}


    http.createServer(app).listen 2470


module.exports = Server
