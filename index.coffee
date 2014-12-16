###*
 # @ngdoc overview
 # @name ngAuth
 # @description
 # Authorization Component for UI-ROUTER States
 # Authentication is done by submitting the login form  ( server side ). Result stored as cookie
###

require './services/auth_service'
require './services/user_session_service'
require './services/access_manager_service'
require './services/user_roles_service'
require './directives/access_group_directive'

angular.module 'rawc0der.common.ngAuth', [
  'rawc0der.common.ngAuth.services.AuthorizationService'
  'rawc0der.common.ngAuth.services.UserSessionService'
  'rawc0der.common.ngAuth.services.AccessManagerService'
  'rawc0der.common.ngAuth.services.UserRoles'
  'rawc0der.common.ngAuth.directives.AccessGroup'
]
