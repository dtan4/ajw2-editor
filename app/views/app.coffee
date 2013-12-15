class Element
  constructor: (type, value, elements) ->
    @type = type
    @value = value
    @elements = elements

interfacesCtrl = ($scope) ->
  $scope.elements = []

  $scope.addElement = ->
    $scope.elements.push(new Element($scope.elemType, $scope.elemValue, []))
    $scope.elemType = ''
    $scope.elemValue = ''

  $scope.addChildElem = (el, elemType, elemValue) ->
    el.elements.push(new Element(elemType, elemValue, []))
    elemType = ''
    elemValue = ''

# http://stackoverflow.com/questions/13166319/create-an-unordered-list-n-levels-deep-using-angularjs
interfacesTree = ->
  {
    template: '<ul><tree-node ng-repeat="el in elements"></tree-node></ul>'
    restrict: 'E',
    replace: true,
    scope: {
      elements: '=elements'
    }
  }

interfacesTreeNode = ($compile) ->
  template = """
<li>
  <div ng-controller="InterfacesCtrl">
    <form class="form-inline" role="form" ng-submit="addChildElem(el, elemType, elemValue)">
      <label style="font-size:x-large">{{el.type}}</label>
      <label>{{el.value}}</label>
      <div class="form-group">
        <input class="form-control" type="text" ng-model="elemType" placeholder="type" required="true" />
      </div>
      <div class="form-group">
        <input class="form-control" type="text" ng-model="elemValue" placeholder="value (optional)" />
      </div>
      <div class="form-group">
        <button class="btn btn-default" type="submit">Add child</button>
      </div>
    </form>
  </div>
</li>
  """
  {
    template: template
    restrict: 'E',
    link: (scope, elm, attrs) ->
      children = $compile('<tree elements="el.elements"></tree>')(scope)
      elm.append(children)
  }


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
  .directive('tree', interfacesTree)
  .directive('treeNode', interfacesTreeNode)
