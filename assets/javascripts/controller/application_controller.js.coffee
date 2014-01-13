app.controller 'ApplicationCtrl', ($scope, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.$storage.appName = "Ajw2 Application" unless $scope.$storage.appName

  $scope.$watch '$storage.appName', (newValue, oldValue) ->
    $scope.$emit 'sendAppName', appName: newValue

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'application', params: { appName: $scope.$storage.appName }

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.appName = 'Ajw2 Application'
