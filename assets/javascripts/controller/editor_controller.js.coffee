app.controller 'EditorCtrl', ($rootScope, $http, $window) ->
  $rootScope.appName = ''
  $rootScope.params = {}

  receivedAllModels = ->
    (model for model in ['application', 'interface', 'database', 'event'] when $rootScope.params[model] is undefined).length == 0

  $rootScope.downloadApp = ->
    $rootScope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

    while not receivedAllModels()
      continue

    $http.post('/download', $rootScope.params).success (data, status, headers, config) ->
      console.log data

  $rootScope.downloadSource = ->
    $rootScope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

    while not receivedAllModels()
      continue

    blob = new Blob [JSON.stringify $rootScope.params]
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
    $rootScope.appName = message.appName
