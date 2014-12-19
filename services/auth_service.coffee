###* 
 # @ngdoc factory
 # @name AuthorizationService
 # @description
 # Request authenticated user details / Authorize based on Role
 #  - GET /users/current -> {return object}
 # # If the user is authenticated result is {user:{...},organisation:[..]}
 # # If the user is not authenticated {error: "..." } 
 #  - obtain admin status by authorizing the current user
###
angular.module('rawc0der.common.ngAuth.services.AuthorizationService', [])
  .factory 'AuthService', ['$http', '$q', 'UserSession', 'AccessManager','$rootScope', '$window', '$timeout', ($http, $q, UserSession, AccessManager, $rootScope, $window, $timeout) ->
    _errors: null
    _isLoggedIn: false
    _isAdmin: (role) ->
      AccessManager.verifyAdminRole role
    _isAuthenticated: (userData) ->
      userData.role?
    _isAuthotizedRole: (group, role) ->
      AccessManager.verifyRoleAccess group ,role
    _denyAccess: (err, userData)->
      @_isLoggedIn = false
      UserSession.endSession()
      @_errors = 
        error: err 
        details: userData
      @_deferred.reject @_errors
      # throw Error('access denied')
      #######  TODO trow error catched by Global Error Handler with Severity Warning 
    _grantAccess: (userData) ->
      @_isLoggedIn = true
      @_deferred.resolve 
        isAdmin: @_isAdmin UserSession.getRole()
        details: userData
    _authorizeUserCredentials: (userData, group) ->
      if @_isAuthenticated userData
        UserSession.setSessionData(userData)
        if @_isAuthotizedRole group, UserSession.getRole()
          @_grantAccess userData
        else
          @_denyAccess 'Not authorized', userData
      else
          @_denyAccess 'Not authenticated', userData
    ###
      activate _mockUser details
      @_authorizeUserCredentials @_userMock, opts?.group
    ###
    _userMock:
      user: 
        firstName: 'John'
        lastName: 'Doe'
        role: 'Administrator'
      organisation: null
    ###*
     # @name authorize user request
     # @param {object} opts - Current user Group name
     # # Options object passed in when calling the authorization request
    ###
    init: ->
      @_deferred = $q.defer()
      $rootScope.$on 'refresh:session', (e, data) ->
        if data.userData?
          UserSession.setSessionData(data.userData)
          $rootScope.$broadcast 'refresh:user:data'

    _logoutAction: =>
      @_isLoggedIn = false
      UserSession.endSession()
      $window.location.href = $window.location.origin + "/logout"

    logout: ->$timeout @_logoutAction, 500

    refreshUserSession: ->
      @_refreshDeferred = $q.defer()
      $http.get('/api/users/current')
        .success (userResponse) =>
          UserSession.setSessionData(userResponse)
          @_refreshDeferred.resolve UserSession.getSessionData()
        .error (err) ->
          @_refreshDeferred.reject err
      @_refreshDeferred.promise

    authorize: (opts) ->
      $http.get('/api/users/current')
        .success (userResponse) =>
          @_authorizeUserCredentials userResponse, opts?.group
        .error (err) ->
          @_deferred.reject err
      @_deferred.promise

    hasViewPermission: (group, role) ->
      @_isAuthotizedRole group, role ? UserSession.getRole()
    
    hasPermission: (group, role) ->
      _permissionDeffered = $q.defer()
      @_deferred.promise.then =>
        _permissionDeffered.resolve( @_isAuthotizedRole group, role ? UserSession.getRole() )
      _permissionDeffered.promise
      
    getLastError: ->
      _.clone @_errors
  ]
