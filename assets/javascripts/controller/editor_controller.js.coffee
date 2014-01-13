app.controller 'EditorCtrl', ($rootScope, $http) ->
  $rootScope.appName = ''
  $rootScope.params = {}

  receivedAllModels = ->
    (model for model in ['application', 'interface', 'database', 'event'] when $rootScope.params[model] is undefined).length == 0

  $rootScope.downloadApp = ->
    $rootScope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

  $rootScope.downloadSource = ->
    console.log 'downloadSource!'

  $rootScope.$on 'getAllElementIds', (_, message) ->
    $rootScope.$broadcast 'requestAllElementIds', {}

  $rootScope.$on 'getAllDatabaseNames', (_, message) ->
    $rootScope.$broadcast 'requestAllDatabaseNames', {}

  $rootScope.$on 'sendModelData', (_, message) ->
    $rootScope.params[message.model] = message.params
    return unless receivedAllModels()
    $http.post('/download', $rootScope.params).success (data, status, headers, config) ->
      console.log data

  $rootScope.$on 'responseAllElementIds', (_, message) ->
    $rootScope.$broadcast 'sendAllElementIds', message

  $rootScope.$on 'responseAllDatabaseNames', (_, message) ->
    $rootScope.$broadcast 'sendAllDatabaseNames', message

  $rootScope.$on 'sendAppName', (_, message) ->
    $rootScope.appName = message.appName
