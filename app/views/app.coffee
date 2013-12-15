class Element
  constructor: (type, id, elClass, value, elements, formVisible) ->
    @type = type
    @id = id
    @elClass = elClass
    @value = value
    @elements = elements
    @formVisible = formVisible

interfacesCtrl = ($scope) ->
  $scope.elements = [new Element('body', '', '', '', [], true)]

  $scope.add = (el, elemType, elemId, elemClass, elemValue) ->
    el.elements.push(new Element(elemType, elemId, elemClass, elemValue, [], true))
    el.formVisible = false

  $scope.delete = (index) ->
    console.log($scope.elements[index])
    $scope.elements.splice(index, 1)

  $scope.deleteAll = ->
    $scope.elements = []

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

databaseCtrl = ($scope) ->
  $scope.databases = []

  $scope.addDatabase = ->
    $scope.databases.push({ 'name': $scope.dbName, 'fields': [] })
    $scope.dbName = ''

  $scope.addField = (index, fieldName, fieldType) ->
    $scope.databases[index].fields.push({
      'name': fieldName,
      'type': fieldType
    })

  $scope.clearDatabases = ->
    $scope.databases.length = 0

angular.module('ajw2Editor', [])
  .controller('DatabaseCtrl', databaseCtrl)
  .controller('InterfacesCtrl', interfacesCtrl)
