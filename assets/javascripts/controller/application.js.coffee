app.controller 'ApplicationCtrl', ($scope, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.appName = $scope.$storage.appName ? "Ajw2 Application"

  $scope.$watch 'appName', (newValue, oldValue) ->
    $scope.$emit 'sendAppName', appName: newValue

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'application', params: { appName: $scope.appName }
