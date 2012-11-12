($ '#search-query').submit ->
  query = ($ '#search-query > input').val()
  type  = ($ '#search-query').data 'search-type'
  switch type
    when 'repo'
      $.get "/search/repo/#{query}", (repos) ->
        ($ "#search-results").html template("search/repo-results")
          repos: repos
    when 'user'
      $.get "/search/user/#{query}", (users) ->
        ($ "#search-results").html template("search/user-results")
          users: users
  false

# default to user search
($ '#search-query').data 'search-type', 'user'
($ 'a.search-user').click ->
  ($ 'a.dropdown-toggle span').html -> 'User'
  ($ '#search-query').data 'search-type', 'user'

($ 'a.search-repo').click ->
  ($ 'a.dropdown-toggle span').html -> 'Repo'
  ($ '#search-query').data 'search-type', 'repo'
