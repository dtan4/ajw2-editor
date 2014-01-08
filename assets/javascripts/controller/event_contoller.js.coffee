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
    constructor: (index, element, func, value) ->
      super(generateActionId(index, 'if'), 'interface')
      @element = element
      @func = func
      @value = value

  class DatabaseAction extends Action
    constructor: (index, database, func, where, fields) ->
      super(generateActionId(index, 'db'), 'database')
      @database = database
      @func = func
      @where = where
      @fields = fields

  class CallUrlAction extends Action
    constructor: (index, method, endpoint, params) ->
      super(generateActionId(index, 'call'), 'callUrl')
      @callType = 'url'
      @method = method
      @endpoint = endpoint
      @params = params

  class CallScriptAction extends Action
    constructor: (index, params, script) ->
      super(generateActionId(index, 'call'), 'callScript')
      @callType = 'script'
      @params = params
      @script = script

  generateEventId = ->
    "events_#{$scope.events.length + 1}"

  generateActionId = (index, actionType) ->
    $scope.actionIds[index] = {} unless $scope.actionIds[index]
    $scope.actionIds[index][actionType] = 0 unless $scope.actionIds[index][actionType]
    $scope.actionIds[index][actionType]++
    $scope.$storage.actionIds = $scope.actionIds
    return "#{actionType}_#{$scope.actionIds[index][actionType]}"

  $scope.$storage = $sessionStorage

  $scope.triggerTypeList = ["onClick", "onChange", "onFocus", "onFocusOut"]
  $scope.actionTypeList = ["interface", "database", "callUrl", "callScript"]

  $scope.events = $scope.$storage.events ? []
  $scope.actionIds = $scope.$storage.actionIds ? []
  $scope.selectedIndex = 0

  $scope.addEvent = ->
    return null unless $scope.triggerType in $scope.triggerTypeList

    trigger = new Trigger($scope.triggerTarget, $scope.triggerType)
    id = generateEventId()
    $scope.events.push new Event(id, $scope.realtime, trigger)
    $scope.triggerTarget = ''
    $scope.triggerType = ''
    $scope.$storage.events = $scope.events
    $scope.selectedIndex = $scope.events.length - 1

  $scope.deleteAllEvents = ->
    $scope.events = []
    $scope.$storage.events = []
    $scope.actionIds = []
    $scope.$storage.actionIds = $scope.actionIds

  $scope.deleteEvent = (index) ->
    $scope.events.splice(index, 1)
    $scope.$storage.events = $scope.events
    $scope.actionIds.splice(index, 1)
    $scope.$storage.actionIds = $scope.actionIds

    if index == $scope.events.length
      $scope.selectedIndex = index - 1
    else
      $scope.selectedIndex = index

  $scope.tabClick = (index) ->
    $scope.selectedIndex = index

  $scope.addAction = (index, actionType) ->
    switch actionType
      when "interface"
        action = new InterfaceAction(index)
      when "database"
        action = new DatabaseAction(index)
      when "callUrl"
        action = new CallUrlAction(index)
      when "callScript"
        action = new CallScriptAction(index)
      else
        return null
    $scope.events[index].actions.push action
    $scope.$storage.events = $scope.events

  $scope.deleteAllActions = (index) ->
    $scope.events[index].actions = []
    $scope.$storage.events = $scope.events
    $scope.actionIds[index] = {}
    $scope.$storage.actionIds = $scope.actionIds

  $scope.actionLabelClass = (actionType) ->
    switch actionType
      when "interface"
        "label-primary"
      when "database"
        "label-success"
      when "callUrl"
        "label-info"
      else
        "label-warning"

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'events', params: { events: $scope.events }
