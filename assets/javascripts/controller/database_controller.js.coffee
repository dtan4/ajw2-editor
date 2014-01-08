app.controller 'DatabaseCtrl', ($scope, $sessionStorage) ->
  class Database
    constructor: (name) ->
      @name = name
      @fields = []

  class Field
    constructor: (name, type) ->
      @name = name
      @type = type

  $scope.$storage = $sessionStorage

  $scope.dbType = $scope.$storage.dbType ? 'mysql'
  $scope.databases = $scope.$storage.databases ? []

  $scope.updateDbType = (dbType) ->
    $scope.dbType = dbType
    $scope.$storage.dbType = dbType

  $scope.validateDbName = (dbName) ->
    isUnique = (db for db in $scope.databases when db.name == dbName).length == 0

  $scope.addDatabase = ->
    $scope.databases.push new Database($scope.dbName)
    $scope.dbName = ''
    $scope.$storage.databases = $scope.databases

  $scope.addField = (index, fieldName, fieldType) ->
    $scope.databases[index].fields.push new Field(fieldName, fieldType)
    $scope.$storage.databases = $scope.databases

  $scope.clearDatabases = ->
    $scope.databases = []
    $scope.$storage.databases = []

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'database', params: { dbType: $scope.dbType, databases: $scope.databases }
