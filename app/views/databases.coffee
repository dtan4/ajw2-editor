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

angular.module('ajw2Editor', []).controller('DatabaseCtrl', databaseCtrl)
