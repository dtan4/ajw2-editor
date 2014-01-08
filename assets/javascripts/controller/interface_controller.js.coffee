app.controller 'InterfaceCtrl', ($scope, $sessionStorage) ->
  class Element
    constructor: (type, id, elClass, value, elements, formVisible) ->
      @type = type
      @id = id
      @elClass = elClass
      @value = value
      @elements = elements
      @formVisible = formVisible

  generateElemId = (elemType) ->
    $scope.elemIds[elemType] = 0 unless $scope.elemIds[elemType]
    $scope.elemIds[elemType]++
    $scope.$storage.elemIds = $scope.elemIds
    return "#{elemType}_#{$scope.elemIds[elemType]}"

  $scope.$storage = $sessionStorage

  $scope.elements = $scope.$storage.elements ? [new Element('body', '', '', '', [], true)]
  $scope.elemIds = $scope.$storage.elemIds ? {}

  $scope.add = (el, elemType, elemId, elemClass, elemValue) ->
    elemId = generateElemId(elemType) unless elemId
    el.elements.push new Element(elemType, elemId, elemClass, elemValue, [], true)
    el.formVisible = false
    $scope.$storage.elements = $scope.elements

  $scope.deleteChildren = (el) ->
    el.elements = []
    $scope.$storage.elements = $scope.elements

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'interface', params: { interfaces: $scope.elements[0].elements }
