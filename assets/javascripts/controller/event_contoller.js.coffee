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
      super(generateActionId(index, 'callurl'), 'callUrl')
      @callType = 'url'
      @method = method
      @endpoint = endpoint
      @params = params

  class CallScriptAction extends Action
    constructor: (index, params, script) ->
      super(generateActionId(index, 'callsc'), 'callScript')
      @callType = 'script'
      @params = params
      @script = script

  $scope.$storage = $sessionStorage

  $scope.$storage.events = [] unless $scope.$storage.events
  $scope.$storage.actionIds = [] unless $scope.$storage.actionIds

  generateEventId = ->
    "events_#{$scope.$storage.events.length + 1}"

  generateActionId = (index, actionType) ->
    $scope.$storage.actionIds[index] = {} unless $scope.$storage.actionIds[index]
    $scope.$storage.actionIds[index][actionType] = 0 unless $scope.$storage.actionIds[index][actionType]
    $scope.$storage.actionIds[index][actionType]++
    return "#{actionType}_#{$scope.$storage.actionIds[index][actionType]}"

  $scope.triggerTypeList = ["onClick", "onChange", "onFocus", "onFocusOut"]
  $scope.actionTypeList = ["interface", "database", "callUrl", "callScript"]

  $scope.selectedIndex = 0

  $scope.addEvent = ->
    return null unless $scope.triggerType in $scope.triggerTypeList

    trigger = new Trigger($scope.triggerTarget, $scope.triggerType)
    id = generateEventId()
    $scope.$storage.events.push new Event(id, $scope.realtime, trigger)
    $scope.triggerTarget = ''
    $scope.triggerType = ''
    $scope.selectedIndex = $scope.$storage.events.length - 1

  $scope.deleteAllEvents = ->
    $scope.$storage.events = []

  $scope.deleteEvent = (index) ->
    $scope.$storage.events.splice(index, 1)
    $scope.$storage.actionIds.splice(index, 1)

    if index == $scope.$storage.events.length
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
    $scope.$storage.events[index].actions.push action

  $scope.deleteAllActions = (index) ->
    $scope.$storage.events[index].actions = []
    $scope.$storage.actionIds[index] = {}

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
    $scope.$emit 'sendModelData', model: 'event', params: { events: $scope.$storage.events }
