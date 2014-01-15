app.controller 'EventCtrl', ($scope, $sessionStorage) ->
  class Event
    constructor: (id, realtime, trigger, actions) ->
      @id = id
      @realtime = realtime
      @trigger = trigger
      @actions = actions

  class Trigger
    constructor: (target, type) ->
      @target = target
      @type = type
      @params = []

  class Action
    constructor: (id, type) ->
      @id = id
      @type = type

  class InterfaceAction extends Action
    constructor: (id, element, func, value) ->
      super(id, 'interface')
      @element = element
      @func = func
      @value = value

  class DatabaseAction extends Action
    constructor: (id, database, func, where, fields) ->
      super(id, 'database')
      @database = database
      @func = func
      @where = where
      @fields = fields

  class CallUrlAction extends Action
    constructor: (id, method, endpoint, params) ->
      super(id, 'callUrl')
      @callType = 'url'
      @method = method
      @endpoint = endpoint
      @params = params

  class CallScriptAction extends Action
    constructor: (id, params, script) ->
      super(id, 'callScript')
      @callType = 'script'
      @params = params
      @script = script

  $scope.$storage = $sessionStorage

  $scope.$storage.events = [] unless $scope.$storage.events
  $scope.$storage.actionIds = [] unless $scope.$storage.actionIds

  loadTrigger = (trigger) ->
    tr = new Trigger(trigger.target, trigger.type)
    # TODO: load trigger.params
    return tr

  loadActions = (actions) ->
    result = []

    for action in actions
      switch action.type
        when 'interface'
          # TODO: load action.params
          act = new InterfaceAction(action.id, action.element, action.func, [])
        when 'database'
          # TODO: load action.where, action.fields
          act = new DatabaseAction(action.id, action.database, action.func, [], [])
        when 'call'
          if action.callType == "url"
            # TODO: load action.params
            act = new CallUrlAction(action.id, action.method, action.endpoint, [])
          else
            # TODO: load action.params
            act = new CallScriptAction(action.id, [], action.script)
        else
          act = null

      result.push act

    return result


  loadEvents = (events) ->
    result = []

    for event in events
      trigger = loadTrigger(event.trigger)
      actions = loadActions(event.action.actions)
      result.push new Event(event.id, event.realtime, trigger, actions)

    return result

  generateEventId = ->
    "events_#{$scope.$storage.events.length + 1}"

  generateActionId = (index, actionType) ->
    $scope.$storage.actionIds[index] = {} unless $scope.$storage.actionIds[index]
    $scope.$storage.actionIds[index][actionType] = 0 unless $scope.$storage.actionIds[index][actionType]
    $scope.$storage.actionIds[index][actionType]++
    return "#{actionType}_#{$scope.$storage.actionIds[index][actionType]}"

  $scope.interfaceIdList = []
  $scope.tableNameList = []
  $scope.triggerTypeList = ['onClick', 'onChange', 'onFocus', 'onFocusOut']
  $scope.actionTypeList = ['interface', 'database', 'callUrl', 'callScript']
  $scope.interfaceFunctionList = ['setValue', 'setText', 'show', 'hide', 'toggle', 'appendElements']
  $scope.databaseFunctionList = ['create', 'read', 'update', 'delete']
  $scope.methodList = ['GET', 'POST']
  $scope.paramTypeList = ['param', 'interface', 'database', 'call']

  $scope.selectedEventIndex = 0
  $scope.selectedActionIndex = 0

  $scope.init = ->
    $scope.$emit 'getAllElementIds'
    $scope.$emit 'getAllTableNames'

  $scope.addEvent = ->
    return null unless $scope.triggerTarget in $scope.interfaceIdList
    return null unless $scope.triggerType in $scope.triggerTypeList

    trigger = new Trigger($scope.triggerTarget, $scope.triggerType)
    id = generateEventId()
    $scope.$storage.events.push new Event(id, $scope.realtime, trigger, [])
    $scope.triggerTarget = ''
    $scope.triggerType = ''
    $scope.realtime = false
    $scope.selectedEventIndex = $scope.$storage.events.length - 1

  $scope.deleteAllEvents = ->
    $scope.$storage.events = []

  $scope.deleteEvent = (index) ->
    $scope.$storage.events.splice(index, 1)
    $scope.$storage.actionIds.splice(index, 1)

    if index == $scope.$storage.events.length
      $scope.selectedEventIndex = index - 1
    else
      $scope.selectedEventIndex = index

  $scope.eventCommunicationType = (realtime) ->
    return if realtime then 'Realtime (WebSocket)' else 'Ajax'

  $scope.tabClick = (index) ->
    $scope.selectedIndex = index

  $scope.addAction = (index, actionType) ->
    switch actionType
      when 'interface'
        id = generateActionId(index, 'if')
        action = new InterfaceAction(id)
      when 'database'
        id = generateActionId(index, 'db')
        action = new DatabaseAction(id)
      when 'callUrl'
        id = generateActionId(index, 'callUrl')
        action = new CallUrlAction(id)
      when 'callScript'
        id = generateActionId(index, 'callSc')
        action = new CallScriptAction(id)
      else
        return null

    $scope.$storage.events[index].actions.push action
    $scope.selectedActionIndex = $scope.$storage.events[index].actions.length - 1

  $scope.deleteAllActions = (index) ->
    $scope.$storage.events[index].actions = []
    $scope.$storage.actionIds[index] = {}

  $scope.deleteAction = (eventIndex, actionIndex) ->
    $scope.$storage.events[eventIndex].actions.splice(actionIndex, 1)

    if actionIndex == $scope.$storage.events[eventIndex].actions.length
      $scope.selectedActionIndex = actionIndex - 1
    else
      $scope.selectedActionIndex = actionIndex

  $scope.actionClick = (index) ->
    $scope.selectedActionIndex = index

  $scope.actionLabelClass = (actionType) ->
    switch actionType
      when 'interface'
        'label-primary'
      when 'database'
        'label-success'
      when 'callUrl'
        'label-info'
      else
        'label-warning'

  $scope.forwardAction = (eventIndex, actionIndex) ->
    $scope.swapAction(eventIndex, actionIndex, actionIndex + 1)

  $scope.backwardAction = (eventIndex, actionIndex) ->
    $scope.swapAction(eventIndex, actionIndex, actionIndex - 1)

  $scope.swapAction = (eventIndex, oldIndex, newIndex) ->
    tmp = $scope.$storage.events[eventIndex].actions[oldIndex]
    $scope.$storage.events[eventIndex].actions[oldIndex] = $scope.$storage.events[eventIndex].actions[newIndex]
    $scope.$storage.events[eventIndex].actions[newIndex] = tmp
    $scope.selectedActionIndex = newIndex

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'event', params: { events: $scope.$storage.events }

  $scope.$on 'sendAllElementIds', (_, args) ->
    $scope.interfaceIdList = args.id

  $scope.$on 'sendAllTableNames', (_, args) ->
    $scope.tableNameList = args.name

  $scope.$on 'cleanup', (_, args) ->
    $scope.$storage.events = []
    $scope.$storage.actionIds = []

  $scope.$on 'loadSource', (_, source) ->
    $scope.$storage.events = loadEvents(source.event.events)
    $scope.$storage.actionids = []
