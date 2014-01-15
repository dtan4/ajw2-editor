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

  $scope.addLocalStylesheet = (src) ->
    $scope.$storage.css.push new Resource(true, src)

  $scope.addRemoteStylesheet = (src) ->
    $scope.$storage.css.push new Resource(false, src)

  $scope.addLocalJavaScript = (src) ->
    $scope.$storage.js.push new Resource(false, src)

  $scope.addRemoteJavaScript = (src) ->
    $scope.$storage.js.push new Resource(true, src)

  $scope.deleteStylesheet = (index) ->
    $scope.$storage.css.splice(index, 1)

  $scope.deleteJavaScript = (index) ->
    $scope.$storage.js.splice(index, 1)

  $scope.resourceType = (remote) ->
    if remote then 'remote' else 'local'

  $scope.resourceLabelClass = (remote) ->
    if remote then 'label-success' else 'label-warning'

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
