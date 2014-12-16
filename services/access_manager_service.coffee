###*
 # @ngdoc factory
 # @name AccessManager
 # @description
 # # Responsible for Access Control  
 # Verify is the user roles has role access permission
 # Verify is the user is from admin group
 # Get Group for the current user
###
angular.module('rawc0der.common.ngAuth.services.AccessManagerService', [])
  .factory 'AccessManager', ['USER_ROLES', (USER_ROLES) ->
    verifyAdminRole : (role) ->
      _.contains USER_ROLES.groups.admin, role 
    verifyRoleAccess: (group="all", role) ->
      @_isRegisteredRole(role) and @_hasGroupPerimission(group, role) 
    _hasGroupPerimission: (group, role) ->
      _.contains USER_ROLES.groups[group], role 
    _isRegisteredRole: (role) ->
      _.contains _.flatten( _.map USER_ROLES.groups, (v) -> v ) , role 
    getUserGroup: (role) ->
      _group = null
      _.map USER_ROLES.groups, (roles, group) ->
        if _.contains roles, role
          _group = group
      _group
  ]
