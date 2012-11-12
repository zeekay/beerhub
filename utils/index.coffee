async = require 'async'
fs    = require 'fs'
path  = require 'path'

exports.walkdir = (dir, callback) ->
  wrench = require 'wrench'
  files = []
  wrench.readdirRecursive dir, (err, _files) ->
    unless _files?
      return callback err, files

    for file in _files
      files.push path.join dir, file

# Compile client-side application code and templates.
exports.compile = (options, callback) ->
  compileJade = (file, _callback) ->
    jade = require 'jade'
    fs.readFile file, 'utf8', (err, content) ->
      return callback err if err
      fn = jade.compile content, {client: true, compileDebug: false}

      key = file.replace /.jade$/, ''
      key = key.replace options.templatesPath, ''
      key = key.replace /^\/|\/$/, ''
      value = fn.toString().replace /function anonymous/, 'function'

      _callback null, """
        "#{key}": #{value}
        """

  compileCoffee = (file, _callback) ->
    coffee = require 'coffee-script'
    fs.readFile file, 'utf8', (err, content) ->
      return callback err if err
      code = coffee.compile content, base: true
      file = file.replace options.basePath, ''
      file = file.replace /^\//, ''
      _callback null, "// #{file}\n" + code

  templateRe = /template\(['"]([a-zA-Z0-9_/-]+)['"]\)/gm

  exports.walkdir options.basePath, (err, files) ->
    return callback err if err

    # compile all coffeescript
    async.map files, compileCoffee, (err, code) ->
      return callback err if err

      # find all template calls
      templates = []
      for file in code
        while match = templateRe.exec file
          templates.push (path.join options.templatesPath, match[1]) + '.jade'

      # compile all templates
      async.map templates, compileJade, (err, jade) ->
        return callback err if err

        templates = """
        var template = (function() {
          var templates = {
            #{jade.join ',\n'}
          };

          return function(name) {
            var _template = templates[name];
            if (!_template) {
              throw new Error('Template "' + name + '" does not exist');
            }
            return _template;
          };

        }());
        """

        code.unshift templates
        callback null, code.join '\n'
