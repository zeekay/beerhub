path = require 'path'

module.exports = settings = {}

settings.BASE_PATH       = path.dirname __dirname
settings.STATIC_PATH     = settings.BASE_PATH + '/static'
settings.BUILD_PATH      = settings.BASE_PATH + '/dist'
settings.JS_PATH         = settings.BASE_PATH + '/assets/js'
settings.CSS_PATH        = settings.BASE_PATH + '/assets/css'
settings.TEMPLATES_PATH  = settings.BASE_PATH + '/templates'

settings.STATIC_URL      = '/assets'
settings.JS_URL          = settings.STATIC_URL + '/js/app.js'
settings.CSS_URL         = settings.STATIC_URL + '/css/app.css'

settings.MONGO_URL       = 'mongodb://localhost/beerhub'
settings.REDIS_HOST      = 'localhost'
settings.REDIS_PORT      = 6379
settings.REDIS_PASS      = ''

settings.SESSION_SECRET  = 'n0w1sth3t1mef0rb33r'

settings.GITHUB_CALLBACK = 'http://localhost:3000/auth/github/callback'
settings.GITHUB_CLIENT   = '233618e768b1d79543f4'
settings.GITHUB_SECRET   = 'f3d58e141ab7003ebb4927dd45dbfdcb839e0ca1'

settings.PORT            = 3000
