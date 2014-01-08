app.controller 'DatabaseCtrl', ($scope, $sessionStorage) ->
  class Database
    constructor: (name) ->
      @name = name
      @fields = []

  class Field
    constructor: (name, type, nullable) ->
      @name = name
      @type = type
      @null = nullable

  $scope.$storage = $sessionStorage

  $scope.$storage.dbType = 'mysql' unless $scope.$storage.dbType
  $scope.$storage.databases = [] unless $scope.$storage.databases
  $scope.selectedIndex = 0

  $scope.fieldTypeList =
    ['string', 'text', 'integer', 'float', 'decimal', 'datatime', 'timestamp', 'time', 'date', 'binary', 'boolean']

  $scope.updateDbType = (dbType) ->
    $scope.$storage.dbType = dbType

  $scope.validateDbName = (dbName) ->
    isUnique = (db for db in $scope.$storage.databases when db.name == dbName).length == 0

  $scope.addDatabase = ->
    $scope.$storage.databases.push new Database($scope.dbName)
    $scope.dbName = ''
    $scope.selectedIndex = $scope.$storage.databases.length - 1

  $scope.deleteAllDatabases = ->
    $scope.$storage.databases = []

  $scope.deleteDatabase = (index) ->
    $scope.$storage.databases.splice(index, 1)

    if index == $scope.$storage.databases.length
      $scope.selectedIndex = index - 1
    else
      $scope.selectedIndex = index

  $scope.tabClick = (index) ->
    $scope.selectedIndex = index

  $scope.addField = (index, fieldName, fieldType, nullable) ->
    $scope.$storage.databases[index].fields.push new Field(fieldName, fieldType, nullable)

  $scope.deleteAllFields = (index) ->
    $scope.$storage.databases[index].fields = []

  $scope.deleteField = (databaseIndex, fieldIndex) ->
    $scope.$storage.databases[databaseIndex].fields.splice(fieldIndex, 1)

  $scope.nullableText = (nullable) ->
    if nullable then "" else "NOT NULL"

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'database', params: { dbType: $scope.$storage.dbType, databases: $scope.$storage.databases }
