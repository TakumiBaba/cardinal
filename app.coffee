# requirements

cluster = require 'cluster'
http = require 'http'
path = require 'path'
os = require 'os'

express = require 'express'
mongoose = require 'mongoose'
direquire = require 'direquire'
connect =
  assets: require 'connect-assets'
  static: require 'st'
  session: (require 'connect-mongo') express


# config

config = require path.resolve 'config', 'application'
config.port = process.env.PORT || config.port || 3000
config.env = process.env.NODE_ENV || config.env || 'development'
process.env.NODE_ENV = config.env


# database

mongo = mongoose.connect config.mongo[config.env]


# applcation

app = express()

app.disable 'x-powered-by'
app.set 'config', config
app.set 'helper', direquire path.resolve 'helper'
app.set 'models', direquire path.resolve 'models'
app.set 'events', direquire path.resolve 'events'
app.set '', path.resolve 'views'
app.set 'view engine', 'jade'

unless config.env is 'production'
  app.locals.pretty = yes

app.use express.favicon path.resolve 'public', 'favicon.ico'
app.use connect.assets buildDir: 'public'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
  secret: 'keyboard cat'
  store: new connect.session mongoose_connection: mongoose.connections[0]
  cookie: maxAge: Date.now() + (config.maxage || 60*60*24*7)
app.use app.router
app.use connect.static
  path: path.resolve 'public'
  url: '/'
  index: no
  passthrough: yes
app.use app.settings.helper.logger yes
app.use (require path.resolve 'config', 'routes') app

if process.env.NODE_ENV is 'development'
  app.use express.errorHandler()


# server

if cluster.isMaster
  (require path.resolve 'config', 'migration') app, ->
    cluster.fork() for i in [0...os.cpus().length]
    cluster.on 'exit', cluster.fork
else
  http.createServer(app).listen config.port, ->
    console.log "HTTPServer pid:#{process.pid} port:#{config.port}"
