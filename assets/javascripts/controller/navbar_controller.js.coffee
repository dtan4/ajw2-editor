app.controller 'NavbarCtrl', ($rootScope, $scope, $http, $window) ->
  $scope.params = {}
  $scope.appName = ""
  $scope.disableButton = false

  receivedAllModels = ->
    (model for model in ['application', 'interface', 'database', 'event'] when $scope.params[model] is undefined).length == 0

  $scope.createNew = ->
    $rootScope.$broadcast 'cleanup', {}

  $scope.openSourceFile = (evt) ->
    sourceFile = evt.target.files[0]

    # FIXME: Chrome on Linux does not recognize Content-Type
    unless sourceFile.type == 'application/json'
      console.error 'invalid file'
      return null

    reader = new FileReader()
    reader.onload = (file) ->
      source = JSON.parse file.target.result
      $rootScope.$broadcast 'loadSource', source

    reader.readAsText(sourceFile)

  $scope.refreshTabs = ->
    $rootScope.$broadcase 'refreshTab', {}

  $scope.downloadApp = ->
    $scope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

    setTimeout ->
      return unless receivedAllModels()

      onSuccess = (data, status, headers, config) ->
        id = data.id
        name = data.name
        $window.open('/download?id=' + id + '&name=' + name)

      onError = (data, status, headers, config) ->
        alert 'Failed to create application package! Check console for detail.'
        console.error data.message

      $http.post('/download', $scope.params).success(onSuccess).error(onError)
    , 1000

  $scope.createSourceUrl = ->
    $scope.params = {}
    $rootScope.$broadcast 'requestModelData', {}
    $scope.disableButton = true

    setTimeout ->
      return unless receivedAllModels()

      blob = new Blob [angular.toJson($scope.params, true)], type: 'application/json'
      $scope.disableButton = false
      url = $window.URL.createObjectURL(blob)
      $('#downloadLink').attr('href', url)
    , 500

  $rootScope.$on 'getAllElementIds', (_, message) ->
    $rootScope.$broadcast 'requestAllElementIds', {}

  $rootScope.$on 'getAllTableNames', (_, message) ->
    $rootScope.$broadcast 'requestAllTableNames', {}

  $rootScope.$on 'responseAllElementIds', (_, res) ->
    $rootScope.$broadcast 'sendAllElementIds', res

  $rootScope.$on 'responseAllTableNames', (_, res) ->
    $rootScope.$broadcast 'sendAllTableNames', res

  $rootScope.$on 'sendModelData', (_, message) ->
    $scope.params[message.model] = message.params

  $rootScope.$on 'sendAppName', (_, message) ->
    $scope.appName = message.name
