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

  loadElements = (elements) ->
    result = []

    for elem in elements
      elClass = elem['class'] || ''
      value = elem['value'] || ''
      children = if elem['children'] then loadElements(elem['children']) else []
      el = new Element(elem.type, elem.id, elClass, value, children, false)
      result.push el

    return result

  $scope.add = (el, elemType, elemId, elemClass, elemValue) ->
    elemId = generateElemId(elemType) unless elemId
    el.elements.push new Element(elemType, elemId, elemClass, elemValue, [], true)
    el.formVisible = false
    $scope.$emit 'responseAllElementIds', id: $scope.getElementIds($scope.$storage.elements[0].elements)

  $scope.deleteChildren = (el) ->
    el.elements = []
    el.formVisible = true
    $scope.$emit 'responseAllElementIds', id: $scope.getElementIds($scope.$storage.elements[0].elements)

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

  $scope.getElementIds = (elements) ->
    result = []

    for el in elements
      result.push el.id
      result.push $scope.getElementIds(el.elements) if el.elements.length > 0

    return [].concat.apply [], result

  $scope.$on 'requestAllElementIds', (_, args) ->
    $scope.$emit 'responseAllElementIds', id: $scope.getElementIds($scope.$storage.elements[0].elements)

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'interface', params: { interfaces: $scope.$storage.elements[0].elements }

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.elements = [new Element('body', '', '', '', [], true)]
    $scope.$storage.elemIds = {}

  $scope.$on 'loadSource', (_, source) ->
    $scope.$storage.elements = [new Element('body', '', '', '', loadElements(source.interface.elements), true)]
    $scope.$storage.elemIds = {}
