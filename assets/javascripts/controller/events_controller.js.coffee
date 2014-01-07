app.controller 'EventsCtrl', ($scope, $sessionStorage) ->
  class Event
    constructor: (id, realtime, trigger) ->
      @id = id
      @realtime = realtime
      @trigger = trigger
      @actions = []

  class Trigger
    constructor: (id, type) ->
      @id = id
      @type = type
      @params = []

  class Action
    constructor: (id, type) ->
      @id = id
      @type = type

  class InterfaceAction extends Action
    constructor: (element, func, value) ->
      super('hoge', 'fuga')
      @element = element
      @func = func
      @value = value

  class DatabaseAction extends Action
    constructor: (database, func, where, fields) ->
      super('hoge', 'fuga')
      @database = database
      @func = func
      @where = where
      @fields = fields

  class UrlCallAction extends Action
    constructor: (method, endpoint, params) ->
      super('hoge', 'fuga')
      @callType = 'url'
      @method = method
      @endpoint = endpoint
      @params = params

  class ScriptCallAction extends Action
    constructor: (params, script) ->
      super('hoge', 'fuga')
      @callType = 'script'
      @params = params
      @script = script

  generateEventId = ->
    "events_#{$scope.events.length + 1}"

  $scope.$storage = $sessionStorage

  $scope.events = $scope.$storage.events ? []

  $scope.addEvent = ->
    trigger = new Trigger($scope.triggerTarget, $scope.triggerType)
    id = generateEventId()
    $scope.events.push new Event(id, $scope.realtime, trigger)
    $scope.$storage.events = $scope.events

  $scope.clearAllEvents = ->
    $scope.events = []

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'events', params: { events: $scope.events }
