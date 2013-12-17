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
  $scope.elemIds = $scope.$storage.elemIds ? {}

  $scope.add = (el, elemType, elemId, elemClass, elemValue) ->
    elemId = $scope.generateElemId(elemType) unless elemId
    el.elements.push(new Element(elemType, elemId, elemClass, elemValue, [], true))
    el.formVisible = false
    $scope.$storage.elements = $scope.elements

  $scope.generateElemId = (elemType) ->
    $scope.elemIds.elemType = 0 unless $scope.elemIds.elemType
    $scope.elemIds.elemType++
    $scope.$storage.elemIds = $scope.elemIds
    return "#{elemType}_#{$scope.elemIds.elemType}"

  $scope.deleteChildren = (el) ->
    el.elements = []
    $scope.$storage.elements = $scope.elements

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

class Database
  constructor: (name) ->
    @name = name
    @fields = []

class Field
  constructor: (name, type) ->
    @name = name
    @type = type

databasesCtrl = ($scope, $localStorage, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.dbType = $scope.$storage.dbType ? 'mysql'
  $scope.databases = $scope.$storage.databases ? []

  $scope.updateDbType = (dbType) ->
    $scope.dbType = dbType
    $scope.$storage.dbType = dbType

  $scope.addDatabase = ->
    $scope.databases.push(new Database($scope.dbName))
    $scope.dbName = ''
    $scope.$storage.databases = $scope.databases

  $scope.addField = (index, fieldName, fieldType) ->
    $scope.databases[index].fields.push(new Field(fieldName, fieldType))
    $scope.$storage.databases = $scope.databases

  $scope.clearDatabases = ->
    $scope.databases = []
    $scope.$storage.databases = []

angular.module('ajw2Editor', ['ngStorage'])
  .controller('DatabasesCtrl', databasesCtrl)
  .controller('InterfacesCtrl', interfacesCtrl)
