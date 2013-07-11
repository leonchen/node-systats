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
      $data = req.query

    app.get '/', (req, res) =>
      res.render 'index', {data: $data}

    http.createServer(app).listen 2470


module.exports = Server
