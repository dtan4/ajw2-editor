$ ->
  storage = localStorage

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
    if !dbName.match(/^[0-9a-zA-Z]+$/)
      alert 'Invalid database name!'
      return
    else
      $('#dbTabNav .active').removeClass 'active'
      $('#dbTabContent .active').removeClass 'active'
      $('#dbTabNav').append $('<li class="active"><a href="#' + dbName + 'Tab" data-toggle="tab">' + dbName + '</a></li>')
      $.tmpl(newTabTemplate, { dbName: dbName }).appendTo $('#dbTabContent')
      $('#' + dbName + 'newFieldBtn').bind('click',
        addNewField(dbName, $('#' + dbName + 'newFieldName').val(), $('#' + dbName + 'newFieldType').val()))
      $('#dbTabContent a:last').tab('show')
      addToDBList(dbName)

  clearDatabase = ->
    delete storage.dbList if storage.dbList
    $('#dbTabNav').html ''
    $('#dbTabContent').html ''

  addToDBList = (dbName) ->
    if storage.dbList
      dbList = JSON.parse storage.dbList
    else
      dbList = []

    dbList.push dbName
    storage.dbList = JSON.stringify dbList

  dbExists = (dbName) ->
    if storage.dbList
      dbList = JSON.parse storage.dbList
      return dbList.indexOf(dbName) >= 0
    else
      return false

  addNewField = (db, fieldName, fieldType) ->
    console.log db, fieldName, fieldType
