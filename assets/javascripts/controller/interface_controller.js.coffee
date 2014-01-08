app.controller 'InterfaceCtrl', ($scope, $sessionStorage) ->
  class Element
    constructor: (type, id, elClass, value, elements, formVisible) ->
      @type = type
      @id = id
      @elClass = elClass
      @value = value
      @elements = elements
      @formVisible = formVisible

  $scope.$storage = $sessionStorage

  $scope.$storage.elements = [new Element('body', '', '', '', [], true)] unless $scope.$storage.elements
  $scope.$storage.elemIds = {} unless $scope.$storage.elemIds

  generateElemId = (elemType) ->
    $scope.$storage.elemIds[elemType] = 0 unless $scope.$storage.elemIds[elemType]
    $scope.$storage.elemIds[elemType]++
    return "#{elemType}_#{$scope.$storage.elemIds[elemType]}"

  $scope.add = (el, elemType, elemId, elemClass, elemValue) ->
    elemId = generateElemId(elemType) unless elemId
    el.elements.push new Element(elemType, elemId, elemClass, elemValue, [], true)
    el.formVisible = false

  $scope.deleteChildren = (el) ->
    el.elements = []
    el.formVisible = true

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'interface', params: { interfaces: $scope.$storage.elements[0].elements }
