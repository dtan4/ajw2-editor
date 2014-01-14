app.controller 'ApplicationCtrl', ($scope, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.$storage.name = "Ajw2 Application" unless $scope.$storage.name

  $scope.$watch '$storage.name', (newValue, oldValue) ->
    $scope.$emit 'sendAppName', name: newValue

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'application', params: { name: $scope.$storage.name }

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.name = 'Ajw2 Application'

  $scope.$on 'loadSource', (_, source) ->
    $scope.$storage.name = source.application.name
