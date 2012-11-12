express    = require 'express'
passport   = require 'passport'
path       = require 'path'
utils      = require './utils'

module.exports = app = express()
settings = require './settings'

sessionStore = do ->
  redis      = require 'redis'
  client     = redis.createClient settings.REDIS_PORT, settings.REDIS_HOST

  if settings.REDIS_PASS?
    client.auth settings.REDIS_PASS, (err) ->
      console.error err if err

  new ((require 'connect-redis')(express))
    client: client

{Strategy} = require('passport-github')
passport.use new Strategy
  clientID: settings.GITHUB_CLIENT
  clientSecret: settings.GITHUB_SECRET
  callbackURL: settings.GITHUB_CALLBACK
, (accessToken, refreshToken, profile, done) ->
  process.nextTick ->
    done null, profile

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (id, done) ->
  done null, id

app.configure ->
  require('mongoose').connect settings.MONGO_URL

  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use express.session
    cookie:
      maxAge: 14400000
    secret: settings.SESSION_SECRET
    store: sessionStore

  app.use passport.initialize()
  app.use passport.session()

  app.set 'view engine', 'jade'
  app.set 'views', settings.TEMPLATES_PATH
  require('./utils/helpers') app

  require('./routes/account') app
  require('./routes') app

app.configure 'development', ->
  app.use require('stylus').middleware
    src:  settings.BASE_PATH
    dest: settings.STATIC_PATH

  app.get settings.JS_URL, (req, res) ->
    options =
      basePath: settings.JS_PATH
      templatesPath: settings.TEMPLATES_PATH
    utils.compile options, (err, content) ->
      console.log err if err

      res.header 'Content-Type', 'application/javascript'
      res.send content

  app.use express.static settings.STATIC_PATH

  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

app.run = ->
  app.listen settings.PORT
  console.log "beerhub running @ http://localhost:#{settings.PORT} in #{app.get 'env'} mode"
