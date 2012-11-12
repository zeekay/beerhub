settings = require '../settings'

module.exports = (app) ->
  app.locals.static = (file) ->
    settings.STATIC_URL + file

  app.use (req, res, next) ->
    res.locals.authenticated = req.isAuthenticated() or false
    res.locals.path = req.url.replace /\/$|#.*/, ''
    next()
