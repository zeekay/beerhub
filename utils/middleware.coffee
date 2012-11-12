exports.authRequired = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  res.redirect '/login'
