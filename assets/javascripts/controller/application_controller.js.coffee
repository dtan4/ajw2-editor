app.controller 'ApplicationCtrl', ($scope, $sessionStorage) ->
  class Resource
    constructor: (remote, src) ->
      @remote = remote
      @src = src

  $scope.$storage = $sessionStorage

  $scope.$storage.name = "Ajw2 Application" unless $scope.$storage.name
  $scope.$storage.css = [] unless $scope.$storage.css
  $scope.$storage.js = [] unless $scope.$storage.js

  loadResources = (resources) ->
    result = []

    for resource in resources
      result.push new Resource(resource.remote, resource.src)

    return result

  $scope.addLocalStylesheet = ->
    console.log 'Add local stylesheet'

  $scope.addRemoteStylesheet = ->
    console.log 'Add remote stylesheet'

  $scope.addLocalJavaScript = ->
    console.log 'Add local JavaScript'

  $scope.addRemoteJavaScript = ->
    console.log 'Add remote JavaScript'

  $scope.resourceType = (remote) ->
    if remote then 'remote' else 'local'

  $scope.resourceLabelClass = (remote) ->
    if remote then 'labal-primary' else 'label-warning'

  $scope.$watch '$storage.name', (newValue, oldValue) ->
    $scope.$emit 'sendAppName', name: newValue

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'application', params: {
      name: $scope.$storage.name,
      css: $scope.$storage.css,
      js: $scope.$storage.js
    }

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.name = 'Ajw2 Application'

  $scope.$on 'loadSource', (_, source) ->
    $scope.$storage.name = source.application.name
    $scope.$storage.css = loadResources(source.application.css)
    $scope.$storage.js = loadResources(source.application.js)
