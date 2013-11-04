$ ->
  $('#createEventBtn').click ->
    targetId = $('#targetId').val()
    eventType = $('#eventType').val()

    if targetId is ''
      alert 'Target element ID is empty!'
    else if eventType is ''
      alert 'Event type is empty!'
    else
      createEvent targetId, eventType
      $('#eventsModal').modal('hide')

  createEvent = (targetId, eventType) ->
    newRow = $('<tr>')
    newRow.append($('<td>').text(targetId))
      .append($('<td>').text(eventType))
    $('#eventsTableBody').append newRow
