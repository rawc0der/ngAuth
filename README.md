ngAuth
======

ngAuthorize - an Authorization and Access Control Service, used for authorizing ui-router states

Use as a parent state for all Autorization required states
Define groups of autorized roles in UserRoles service
Save user session data 

ui-router (state config)
------------------------
'''
angular.module('rawc0der.auth', [
  'ui.router'
  'rawc0der.example.controllers.AuthController'
]).config ($stateProvider) ->
  $stateProvider
    .state 'auth',
      url: '/'
      controller: 'AuthController'
      resolve: 
        Auth: (AuthService) ->
          AuthService.authorize()

angular.module('rawc0der.example', [
  'rawc0der.example.controllers.PageController'
]).config ($stateProvider) ->
  $stateProvider
    .state 'authenticatedSate',
      parent: 'auth'
      Auth: 'authorize'
      resolve: 
        authorize: (Auth) ->
          Auth
      data:
        access_group: 'all'

      ....
'''