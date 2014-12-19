###*
# @ngdoc service
# @name UserSession
# @description
# # Current User Model
# Determines if the user is an administrator based on recieved role
# Retrieve user details from getter methods
###
angular.module('rawc0der.common.ngAuth.services.UserSessionService', [])
  .service 'UserSession', ['$q', '$http', '$interval', ($q, $http, $interval) ->
    _user: null
    _authorizedAssets: null
    _keepAliveInterval: null
    setSessionData: (user) ->
      @_setKeepAliveInterval(user)
      @_user = user
      @_authorizedAssets =
        name: user.userGroup?.organisation.orgName
        id: user.userGroup?.organisation.id
      # console.log 'UserSession new authorization details:', @_user, @_authorizedAssets
    getSessionData: ->
      _.clone
        user: @_user
        organisation: @_authorizedAssets
    hasSessionData: ->
      @_user?
    endSession: ->
      @_user = null
      @_authorizedAssets = null
    getFullName: ->
      @_user.firstName+' '+@_user.lastName
    getRole: ->
      @_user.role
    getAuthorizedAssets: ->
      assets: @_authorizedAssets
    getDecimalFormat: ->
      @_user.numberFormatConfig.decimalSeparator
    getGroupingFormat: ->
      @_user.numberFormatConfig.groupingSeparator
    _setKeepAliveInterval: (user) ->
      if user.sessionNeverExpires then $interval @_keepAliveAction, 600000
    _keepAliveAction: ->
      $http.get('/api/keep-alive')
  ]
