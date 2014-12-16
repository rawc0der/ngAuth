angular.module('rawc0der.common.ngAuth.directives.AccessGroup', [])
  .directive 'authAccessGroup', ['AuthService', (AuthService) ->
    restrict: 'A'
    scope: {
      group: '@authAccessGroup'
      page: '@authPageName'
    }
    link: (scope, elem, attrs) ->
      groups = scope.group.split(' ')
      hasAccess = false
      _.map groups, (group) ->
        if AuthService.hasPermission group
          hasAccess = true
      if not hasAccess
        elem.css display:'none'
        
  ]