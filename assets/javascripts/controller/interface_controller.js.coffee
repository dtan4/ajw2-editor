app.controller 'InterfaceCtrl', ($scope, $sessionStorage) ->
  class Element
    constructor: (type, id, elClass, value, children, formVisible) ->
      @type = type
      @id = id
      @class = elClass
      @value = value
      @children = children
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
    el.children.push new Element(elemType, elemId, elemClass, elemValue, [], true)
    el.formVisible = false
    $scope.$emit 'responseAllElementIds', id: $scope.getElementIds($scope.$storage.elements[0].children)

  $scope.deleteChildren = (el) ->
    el.children = []
    el.formVisible = true
    $scope.$emit 'responseAllElementIds', id: $scope.getElementIds($scope.$storage.elements[0].children)

  $scope.toggleForm = (el) ->
    el.formVisible = !el.formVisible

  $scope.getElementIds = (elements) ->
    result = []

    for el in elements
      result.push el.id
      result.push $scope.getElementIds(el.children) if el.children.length > 0

    return [].concat.apply [], result

  $scope.$on 'requestAllElementIds', (_, args) ->
    $scope.$emit 'responseAllElementIds', id: $scope.getElementIds($scope.$storage.elements[0].children)

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'interface', params: { elements: $scope.$storage.elements[0].children }

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.elements = [new Element('body', '', '', '', [], true)]
    $scope.$storage.elemIds = {}

  $scope.$on 'loadSource', (_, source) ->
    $scope.$storage.elements = [new Element('body', '', '', '', loadElements(source.interface.elements), true)]
    $scope.$storage.elemIds = {}
