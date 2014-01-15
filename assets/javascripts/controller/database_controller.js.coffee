app.controller 'DatabaseCtrl', ($scope, $sessionStorage) ->
  class Table
    constructor: (name) ->
      @name = name
      @fields = []

  class Field
    constructor: (name, type, nullable) ->
      @name = name
      @type = type
      @nullable = nullable

  $scope.$storage = $sessionStorage

  $scope.$storage.dbType = 'mysql' unless $scope.$storage.dbType
  $scope.$storage.tables = [] unless $scope.$storage.tables
  $scope.selectedIndex = 0

  $scope.fieldTypeList =
    ['string', 'text', 'integer', 'float', 'decimal', 'datatime', 'timestamp', 'time', 'date', 'binary', 'boolean']

  loadTables = (tables) ->
    result = []

    for table in tables
      tb = new Table(table.name)

      for field in table.fields
        fl = new Field(field.name, field.type, field['nullable'])
        tb.fields.push fl

      result.push tb

    return result

  $scope.updateDbType = (dbType) ->
    $scope.$storage.dbType = dbType

  $scope.validateTableName = (tableName) ->
    isUnique = (tb for tb in $scope.$storage.tables when tb.name == tableName).length == 0

  $scope.addTable = ->
    $scope.$storage.tables.push new Table($scope.tableName)
    $scope.tableName = ''
    $scope.selectedIndex = $scope.$storage.tables.length - 1
    $scope.$emit 'responseAllTableNames', name: $scope.getTableNames()

  $scope.deleteAllTables = ->
    $scope.$storage.tables = []
    $scope.$emit 'responseAllTableNames', name: $scope.getTableNames()

  $scope.deleteTable = (index) ->
    $scope.$storage.tables.splice(index, 1)

    if index == $scope.$storage.tables.length
      $scope.selectedIndex = index - 1
    else
      $scope.selectedIndex = index

    $scope.$emit 'responseAllTableNames', name: $scope.getTableNames()

  $scope.tabClick = (index) ->
    $scope.selectedIndex = index

  $scope.addField = (index, fieldName, fieldType, nullable) ->
    $scope.$storage.tables[index].fields.push new Field(fieldName, fieldType, nullable)

  $scope.deleteAllFields = (index) ->
    $scope.$storage.tables[index].fields = []

  $scope.deleteField = (tableIndex, fieldIndex) ->
    $scope.$storage.tables[tableIndex].fields.splice(fieldIndex, 1)

  $scope.nullableText = (nullable) ->
    if nullable then "" else "NOT NULL"

  $scope.getTableNames = ->
    result = []
    result.push tb.name for tb in $scope.$storage.tables

    return [].concat.apply [], result

  $scope.$on 'requestAllTableNames', (_, args) ->
    $scope.$emit 'responseAllTableNames', name: $scope.getTableNames()

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'database', params: {
      dbType: $scope.$storage.dbType, tables: $scope.$storage.tables
    }

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.dbType = 'mysql'
    $scope.$storage.tables = []
    $scope.selectedIndex = 0

  $scope.$on 'loadSource', (_, source) ->
    $scope.$storage.dbType = source.database.dbType
    $scope.$storage.tables = loadTables source.database.tables
