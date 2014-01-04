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

  $scope.clearAllEvents = ->
    $scope.events = []

  $scope.$on 'requestModelData', (_, args) ->
    $scope.$emit 'sendModelData', model: 'events', params: { events: $scope.events }
