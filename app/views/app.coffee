app = angular.module 'ajw2Editor', ['ngStorage']

app.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=_csrf]').attr('content')
]


app.controller 'EditorCtrl', ($rootScope, $http) ->
  $rootScope.appName = ''
  $rootScope.params = {}

  receivedAllModels = ->
    (model for model in ['application', 'interfaces', 'databases', 'events'] when $rootScope.params[model] is undefined).length == 0

  $rootScope.downloadApp = ->
    $rootScope.params = {}
    $rootScope.$broadcast 'requestModelData', {}

  $rootScope.$on 'sendModelData', (_, message) ->
    $rootScope.params[message.model] = message.params
    return unless receivedAllModels()
    $http.post('/download', $rootScope.params).success (data, status, headers, config) ->
      console.log data

  $rootScope.$on 'sendAppName', (_, message) ->
    $rootScope.appName = message.appName


app.controller 'ApplicationCtrl', ($scope, $sessionStorage) ->
  $scope.$storage = $sessionStorage

  $scope.appName = $scope.$storage.appName ? "Ajw2 Application"

  $scope.$watch 'appName', (newValue, oldValue) ->
    $scope.$emit 'sendAppName', appName: newValue

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'application', params: { appName: $scope.appName }


app.controller 'InterfacesCtrl', ($scope, $sessionStorage) ->
  class Element
    constructor: (type, id, elClass, value, elements, formVisible) ->
      @type = type
      @id = id
      @elClass = elClass
      @value = value
      @elements = elements
      @formVisible = formVisible

  generateElemId = (elemType) ->
    $scope.elemIds.elemType = 0 unless $scope.elemIds.elemType
    $scope.elemIds.elemType++
    $scope.$storage.elemIds = $scope.elemIds
    return "#{elemType}_#{$scope.elemIds.elemType}"

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
    $scope.$emit 'sendModelData', model: 'interfaces', params: { interfaces: $scope.elements[0].elements }


app.controller 'DatabasesCtrl', ($scope, $sessionStorage) ->
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
    $scope.$emit 'sendModelData', model: 'databases', params: { dbType: $scope.dbType, databases: $scope.databases }


app.controller 'EventsCtrl', ($scope, $sessionStorage) ->
  class Event
    constructor: (realtime, trigger) ->
      @realtime = realtime
      @trigger = trigger
      @action = []

  class Trigger
    constructor: (id, type) ->
      @id = id
      @type = type
      @params = []

  class Action
    constructor: (type) ->
      @type = type

  $scope.$storage = $sessionStorage

  $scope.events = $scope.$storage.events ? []

  $scope.addEvent = ->
    trigger = new Trigger($scope.triggerId, $scope.triggerType)
    $scope.events.push new Event($scope.realtime, trigger)
    $scope.$storage.events = $scope.events

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'events', params: { events: $scope.events }
