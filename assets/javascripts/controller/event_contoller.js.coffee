app.controller 'EventCtrl', ($scope, $sessionStorage) ->
  class Event
    constructor: (id, realtime, trigger, action) ->
      @id = id
      @realtime = realtime
      @trigger = trigger
      @action = action

  class Trigger
    constructor: (target, type, params) ->
      @target = target
      @type = type
      @params = params

  class Parameter
    constructor: (id, type, value) ->
      @id = id
      @type = type
      @value = value

  class ValueBase
    constructor: (type) ->
      @type = type

  class ElementValue extends ValueBase
    constructor: (element, func) ->
      super('element')
      @element = element
      @func = func

  class LiteralValue extends ValueBase
    constructor: (value) ->
      super('literal')
      @value = value

  class ActionValueBase
    constructor: (type, id) ->
      @type = type
      @id = id

  class ActionValueParam extends ActionValueBase
    constructor: (id) ->
      super('param', id)

  class ActionValueDatabase extends ActionValueBase
    constructor: (id, field) ->
      super('db', id)
      @field = field

  class ActionValueCall extends ActionValueBase
    constructor: (id, jsonpath) ->
      super('call', id)
      @jsonpath = jsonpath

  class ActionParam
    constructor: (field, value) ->
      @field = field
      @value = value

  class Action
    constructor: (type, actions) ->
      @type = type
      @actions = actions

  class ActionBase
    constructor: (id, type) ->
      @id = id
      @type = type

  class InterfaceAction extends ActionBase
    constructor: (id, element, func, value) ->
      super(id, 'interface')
      @element = element
      @func = func
      @value = value

  class DatabaseAction extends ActionBase
    constructor: (id, database, func, where, fields) ->
      super(id, 'database')
      @database = database
      @func = func
      @where = where
      @fields = fields

  class CallUrlAction extends ActionBase
    constructor: (id, method, endpoint, params) ->
      super(id, 'callUrl')
      @callType = 'url'
      @method = method
      @endpoint = endpoint
      @params = params

  class CallScriptAction extends ActionBase
    constructor: (id, params, script) ->
      super(id, 'callScript')
      @callType = 'script'
      @params = params
      @script = script

  $scope.$storage = $sessionStorage

  $scope.$storage.events = [] unless $scope.$storage.events
  $scope.$storage.actionIds = [] unless $scope.$storage.actionIds

  $scope.interfaceIdList = []
  $scope.tableNameList = []
  $scope.triggerTypeList = ['onClick', 'onChange', 'onFocus', 'onFocusOut']
  $scope.triggerParamTypeList = ['integer', 'decimal', 'string', 'datetime', 'boolean']
  $scope.valueFuncList = ['getValue']
  $scope.actionTypeList = ['interface', 'database', 'callUrl', 'callScript']
  $scope.interfaceFunctionList = ['setValue', 'setText', 'show', 'hide', 'toggle', 'appendElements']
  $scope.databaseFunctionList = ['create', 'read', 'update', 'delete']
  $scope.methodList = ['GET', 'POST']
  $scope.paramTypeList = ['param', 'interface', 'database', 'call']

  $scope.selectedEventIndex = 0
  $scope.selectedActionIndex = 0

  loadValue = (value) ->
    switch value.type
      when 'element'
        return new ElementValue(value.element, value.func)
      when 'literal'
        return new LiteralValue(value.value)
      else
        return null

  loadParams = (params) ->
    result = []

    for param in params
      value = loadValue(param.value)
      pm = new Parameter(param.id, param.type, value)
      result.push pm

    return result

  loadTrigger = (trigger) ->
    params = loadParams(trigger.params)
    tr = new Trigger(trigger.target, trigger.type, params)

    return tr

  loadActionValue = (value) ->
    switch value.type
      when 'param'
        val = new ActionValueParam(value.id)
      when 'db'
        val = new ActionValueDatabase(value.id, value.field)
      when 'call'
        val = new ActionValueCall(value.id, value.jsonpath)
      else
        val = null

    return val

  loadActionParams = (params) ->
    result = []

    for param in params
      value = loadActionValue(param.value)
      pm = new ActionParam(param.field, value)
      result.push pm

    return result

  loadActions = (actions) ->
    result = []

    for action in actions
      switch action.type
        when 'interface'
          # TODO: load action.params
          act = new InterfaceAction(action.id, action.element, action.func, [])
        when 'database'
          act = new DatabaseAction(action.id, action.database, action.func, loadActionParams(action.where), loadActionParams(action.fields))
        when 'call'
          if action.callType == "url"
            act = new CallUrlAction(action.id, action.method, action.endpoint, loadActionParams(action.params))
          else
            act = new CallScriptAction(action.id, loadActionParams(action.params), action.script)
        else
          act = null

      result.push act

    return result

  loadAction = (action) ->
    type = action.type
    actions = loadActions(action.actions)
    act = new Action(type, actions)

    return act

  loadEvents = (events) ->
    result = []

    for event in events
      trigger = loadTrigger(event.trigger)
      action = loadAction(event.action)
      result.push new Event(event.id, event.realtime, trigger, action)

    return result

  generateEventId = ->
    "events_#{$scope.$storage.events.length + 1}"

  generateActionId = (index, actionType) ->
    $scope.$storage.actionIds[index] = {} unless $scope.$storage.actionIds[index]
    $scope.$storage.actionIds[index][actionType] = 0 unless $scope.$storage.actionIds[index][actionType]
    $scope.$storage.actionIds[index][actionType]++
    return "#{actionType}_#{$scope.$storage.actionIds[index][actionType]}"

  $scope.init = ->
    $scope.$emit 'getAllElementIds'
    $scope.$emit 'getAllTableNames'

  $scope.addEvent = ->
    return null unless $scope.triggerTarget in $scope.interfaceIdList
    return null unless $scope.triggerType in $scope.triggerTypeList

    trigger = new Trigger($scope.triggerTarget, $scope.triggerType, [])
    action = new Action('always', [])
    id = generateEventId()
    $scope.$storage.events.push new Event(id, $scope.realtime, trigger, actions)
    $scope.triggerTarget = ''
    $scope.triggerType = ''
    $scope.realtime = false
    $scope.selectedEventIndex = $scope.$storage.events.length - 1

  $scope.deleteEvent = (index) ->
    $scope.$storage.events.splice(index, 1)
    $scope.$storage.actionIds.splice(index, 1)

    if index == $scope.$storage.events.length
      $scope.selectedEventIndex = index - 1
    else
      $scope.selectedEventIndex = index

  $scope.eventConnectionType = (realtime) ->
    return if realtime then 'Realtime (WebSocket)' else 'Ajax'

  $scope.addElementValueParam = (index, id, type, valueElem, valueFunc) ->
    value = new ElementValue(valueElem, valueFunc)
    param = new Parameter(id, type, value)
    $scope.$storage.events[index].trigger.params.push param

  $scope.addLiteralValueParam = (index, id, type, value) ->
    value = new LiteralValue(value)
    param = new Parameter(id, type, value)
    $scope.$storage.events[index].trigger.params.push param

  $scope.paramValueLabelClass = (type) ->
    switch type
      when 'element'
        return 'label-success'
      when 'literal'
        return 'label-warning'
      else
        return ''

  $scope.paramValueStr = (value) ->
    switch value.type
      when 'element'
        return "#{value.element}: #{value.func}()"
      when 'literal'
        return "#{value.value}"
      else
        return ''

  $scope.deleteTriggerParam = (eventIndex, paramIndex) ->
    $scope.$storage.events[eventIndex].trigger.params.splice(paramIndex, 1)

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

    $scope.$storage.events[index].action.actions.push action
    $scope.selectedActionIndex = $scope.$storage.events[index].action.actions.length - 1

  $scope.deleteAction = (eventIndex, actionIndex) ->
    $scope.$storage.events[eventIndex].action.actions.splice(actionIndex, 1)

    if actionIndex == $scope.$storage.events[eventIndex].action.actions.length
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
    tmp = $scope.$storage.events[eventIndex].action.actions[oldIndex]
    $scope.$storage.events[eventIndex].action.actions[oldIndex] = $scope.$storage.events[eventIndex].action.actions[newIndex]
    $scope.$storage.events[eventIndex].action.actions[newIndex] = tmp
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

  $scope.$on 'refreshTab', (_, args) ->
    $scope.$storage.events = $scope.$storage.events
