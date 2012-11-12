{spawn} = require 'child_process'
fs      = require 'fs'

run = (cmd, callback) ->
  args = cmd.split ' '
  cmd  = args.shift()
  proc = spawn cmd, args

  stderr = ''
  stdout = ''

  proc.stdout.on 'data', (data) ->
    stdout += data
    process.stdout.write data

  proc.stderr.on 'data', (data) ->
    stderr += data
    process.stderr.write data

  proc.on 'exit', (stderr, stdout) ->
    if typeof callback is 'function'
      callback stderr, stdout

task 'build', 'Build project', ->
  settings = require './settings'
  utils    = require './utils'
  wrench   = require 'wrench'

  if !fs.existsSync settings.BUILD_PATH
    fs.mkdirSync settings.BUILD_PATH

  wrench.copyDirRecursive settings.STATIC_PATH, settings.BUILD_PATH, (err) ->
    throw err if err
    options =
      basePath: settings.JS_PATH
      templatesPath: settings.TEMPLATES_PATH

    utils.compile options, (err, code) ->
      if err
        console.log err
        process.exit 1

      # wrap in closure for production
      fs.writeFileSync settings.BUILD_PATH + '/assets/js/app.js', "(function(){#{code}}())"
      process.exit 0

task 'deploy', 'Deploy project with jitsu', ->
  run 'jitsu deploy'

task 'upload', 'Upload static assets to S3', ->
  async    = require 'async'
  knox     = require 'knox'
  mime     = require 'mime'
  settings = require './settings'
  utils    = require './utils'

  s3 = knox.createClient
    key: process.env.AWS_KEY
    secret: process.env.AWS_SECRET
    bucket: 'static.beerhub.io'

  utils.walkdir settings.BUILD_PATH, (err, files) ->
    throw err if err
    upload = (file, callback) ->
      fs.readFile file, (err, content) ->
        if err?
          if err.code == 'EISDIR'
            return callback null
          else
            throw err

        file = file.replace settings.BUILD_PATH, ''
        headers =
          'Content-Type': mime.lookup file
          'x-amz-acl': 'public-read'
        if content.length?
          headers['Content-Length'] = content.length
        req = s3.put file, headers
        req.on 'response', (res) ->
          if res.statusCode == 200
            console.log 'uploaded ' + file
          else
            console.error 'failed to upload ' + file
          callback null
        req.end content

    async.forEach files, upload, (err) ->
      if err
        console.error err
        process.exit 1
      else
        process.exit 0
