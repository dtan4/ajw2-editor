app.controller 'EditorCtrl', ($rootScope, $http) ->
  $rootScope.appName = ''
  $rootScope.params = {}

  receivedAllModels = ->
    (model for model in ['application', 'interface', 'database', 'events'] when $rootScope.params[model] is undefined).length == 0

  $rootScope.downloadApp = ->
    $rootScope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

  $rootScope.downloadSource = ->
    console.log 'downloadSource!'

  $rootScope.$on 'sendModelData', (_, message) ->
    $rootScope.params[message.model] = message.params
    return unless receivedAllModels()
    $http.post('/download', $rootScope.params).success (data, status, headers, config) ->
      console.log data

  $rootScope.$on 'sendAppName', (_, message) ->
    $rootScope.appName = message.appName
