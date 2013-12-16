class Element
  constructor: (type, id, elClass, value, elements, formVisible) ->
    @type = type
    @id = id
    @elClass = elClass
    @value = value
    @elements = elements
    @formVisible = formVisible

interfacesCtrl = ($scope, $localStorage, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.elements = $scope.$storage.elements ? [new Element('body', '', '', '', [], true)]

  $scope.add = (el, elemType, elemId, elemClass, elemValue) ->
    el.elements.push(new Element(elemType, elemId, elemClass, elemValue, [], true))
    el.formVisible = false
    $scope.$storage.elements = $scope.elements

  $scope.deleteChildren = (el) ->
    el.elements = []
    $scope.$storage.elements = $scope.elements

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

databaseCtrl = ($scope, $localStorage, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.databases = []

  $scope.addDatabase = ->
    $scope.databases.push({ 'name': $scope.dbName, 'fields': [] })
    $scope.dbName = ''
    $scope.$storage.databases = $scope.databases

  $scope.addField = (index, fieldName, fieldType) ->
    $scope.databases[index].fields.push({
      'name': fieldName,
      'type': fieldType
    })
    $scope.$storage.databases = $scope.databases

  $scope.clearDatabases = ->
    $scope.databases = []
    $scope.$storage.databases = []

angular.module('ajw2Editor', ['ngStorage'])
  .controller('DatabaseCtrl', databaseCtrl)
  .controller('InterfacesCtrl', interfacesCtrl)
