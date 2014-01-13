app.controller 'NavbarCtrl', ($rootScope, $http) ->
  $rootScope.createNew = ->
    $rootScope.$broadcast 'cleanup', {}

  $rootScope.openSource = ->
    console.log 'openSource'
