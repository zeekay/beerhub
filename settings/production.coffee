module.exports = settings = require './development'

settings.STATIC_URL      = '//static.beerhub.io/assets'
settings.CSS_URL         = settings.STATIC_URL + '/css/app.css'
settings.JS_URL          = settings.STATIC_URL + '/js/app.js'

settings.MONGO_URL       = process.env.MONGO_URL
settings.REDIS_HOST      = process.env.REDIS_HOST
settings.REDIS_PORT      = process.env.REDIS_PORT
settings.REDIS_PASS      = process.env.REDIS_PASS

settings.GITHUB_CALLBACK = process.env.GIHTHUB_CALLBACK
settings.GITHUB_CLIENT   = process.env.GITHUB_CLIENT
settings.GITHUB_SECRET   = process.env.GITHUB_SECRET

settings.PORT            = 80
