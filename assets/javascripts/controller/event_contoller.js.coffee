app.controller 'EventCtrl', ($scope, $sessionStorage) ->
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
      super('hoge', 'interface')
      @element = element
      @func = func
      @value = value

  class DatabaseAction extends Action
    constructor: (database, func, where, fields) ->
      super('hoge', 'database')
      @database = database
      @func = func
      @where = where
      @fields = fields

  class CallUrlAction extends Action
    constructor: (method, endpoint, params) ->
      super('hoge', 'callUrl')
      @callType = 'url'
      @method = method
      @endpoint = endpoint
      @params = params

  class CallScriptAction extends Action
    constructor: (params, script) ->
      super('hoge', 'callScript')
      @callType = 'script'
      @params = params
      @script = script

  generateEventId = ->
    "events_#{$scope.events.length + 1}"

  $scope.$storage = $sessionStorage

  $scope.actionTypeList = ["interface", "database", "callUrl", "callScript"]

  $scope.events = $scope.$storage.events ? []

  $scope.addEvent = ->
    trigger = new Trigger($scope.triggerTarget, $scope.triggerType)
    id = generateEventId()
    $scope.events.push new Event(id, $scope.realtime, trigger)
    $scope.$storage.events = $scope.events
    $scope.triggerTarget = ''
    $scope.triggerType = ''

  $scope.clearAllEvents = ->
    $scope.events = []

  $scope.addAction = (index, actionType) ->
    switch actionType
      when "interface"
        action = new InterfaceAction
      when "database"
        action = new DatabaseAction
      when "callUrl"
        action = new CallUrlAction
      when "callScript"
        action = new CallScriptAction
      else
        return null
    $scope.events[index].actions.push action
    $scope.$storage.events = $scope.events

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'events', params: { events: $scope.events }
