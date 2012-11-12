github   = new (require 'github')
  version: '3.0.0'

module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render 'index'

  app.get '/about', (req, res) ->
    res.render 'about'

  app.get '/contact', (req, res) ->
    res.render 'contact'

  app.get '/search/user/:keyword', (req, res) ->
    github.search.users {keyword: req.params.keyword}, (err, results) ->
      res.json 200, results.users

  app.get '/search/repo/:keyword', (req, res) ->
    github.search.repos {keyword: req.params.keyword}, (err, results) ->
      res.json 200, results.repositories
