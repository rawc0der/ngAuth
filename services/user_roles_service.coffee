###*
 # @ngdoc constant
 # @name USER_ROLES
 # @description
 # ACL module of the component.
###
angular.module('rawc0der.common.ngAuth.services.UserRoles',[])
  .constant 'USER_ROLES',
    groups:
      admin: ['Administrator']
      customer: ['StandardUser']
      dashboardViewer: ['DashboardViewer']
      dashboardAdmin: ['DashboardAdministrator', 'Administrator','StandardUser']
      all: ['Administrator', 'StandardUser', 'DashboardViewer', 'DashboardAdministrator']
