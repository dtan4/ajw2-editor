$ ->
  $('#createBtn').click ->
    alert 'Create New!'

  $('#saveBtn').click ->
    alert 'Save!'

  $('#generateBtn').click ->
    alert 'Generate!'

  $('#createDbBtn').click ->
    dbName = $('#newDbName').val()

    if dbName is ''
      alert 'Database name is empty!'
      # TODO: focus
    else if dbExists(dbName)
      alert 'Database ' + dbName + ' already exists!'
      # TODO: focus
    else
      createDatabase(dbName)
      $('#newDbName').val('')

  $('#clearDbBtn').click ->
    # TODO: confirm
    clearDatabase()

  createDatabase = (dbName) ->
    # TODO: validate dbName
    $('#dbTabNav .active').removeClass 'active'
    $('#dbTabContent .active').removeClass 'active'
    $('#dbTabNav').append $('<li class="active"><a href="#' + dbName + 'Tab" data-toggle="tab">' + dbName + '</a></li>')
    $('#dbTabContent').append($('<div class="tab-pane active" id="' + dbName + 'Tab">')
        .append($('<form class="form-inline" role="form" style="margin-top:10px">')
          .append($('<div class="form-group">')
            .append($('<label class="sr-only" for="'+ dbName + 'newFieldName">'))
            .append($('<input type="text" class="form-control" id="'+ dbName + 'newFieldName" placeholder="Field name">')))
          .append($('<div class="form-group">')
            .append($('<label class="sr-only" for="'+ dbName + 'newFieldType">'))
            .append($('<input type="text" class="form-control" id="'+ dbName + 'newFieldType" placeholder="Field Type" style="margin-left:10px">')))
          .append($('<button type="button" class="btn btn-primary" id="' + dbName + 'newFieldBtn" style="margin-left:20px">').text('Add field')))
        .append($('<table class="table table-striped">')
          .append($('<thead>')
            .append($('<tr>')
              .append($('<th>').text('Field name'))
              .append($('<th>').text('Field type'))))
          .append($('<tbody id="' + dbName + 'table">'))))
    $('#dbTabContent a:last').tab('show')
    addToDBList(dbName)

  clearDatabase = ->
    delete localStorage.dbList if localStorage.dbList
    $('#dbTabNav').html ''
    $('#dbTabContent').html ''

  addToDBList = (dbName) ->
    if localStorage.dbList
      dbList = JSON.parse localStorage.dbList
    else
      dbList = []

    dbList.push dbName
    localStorage.dbList = JSON.stringify dbList

  dbExists = (dbName) ->
    if localStorage.dbList
      dbList = JSON.parse localStorage.dbList
      return dbList.indexOf(dbName) >= 0
    else
      return false
