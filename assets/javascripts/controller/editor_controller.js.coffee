app.controller 'EditorCtrl', ($rootScope, $scope, $http, $window) ->
  $scope.appName = ''
  $scope.params = {}

  receivedAllModels = ->
    (model for model in ['application', 'interface', 'database', 'event'] when $scope.params[model] is undefined).length == 0

  $scope.downloadApp = ->
    $scope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

    while not receivedAllModels()
      continue

    $http.post('/download', $scope.params).success (data, status, headers, config) ->
      console.log data

  $scope.downloadSource = ->
    $scope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

    while not receivedAllModels()
      continue

    blob = new Blob [JSON.stringify $scope.params]
    $window.open $window.URL.createObjectURL(blob)
    return

  $rootScope.$on 'getAllElementIds', (_, message) ->
    $rootScope.$broadcast 'requestAllElementIds', {}

  $rootScope.$on 'getAllDatabaseNames', (_, message) ->
    $rootScope.$broadcast 'requestAllDatabaseNames', {}

  $rootScope.$on 'sendModelData', (_, message) ->
    $rootScope.params[message.model] = message.params

  $rootScope.$on 'responseAllElementIds', (_, message) ->
    $rootScope.$broadcast 'sendAllElementIds', message

  $rootScope.$on 'responseAllDatabaseNames', (_, message) ->
    $rootScope.$broadcast 'sendAllDatabaseNames', message

  $rootScope.$on 'sendAppName', (_, message) ->
    $scope.name = message.name
