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
    else if dbExists(dbName)
      alert 'Database ' + dbName + ' already exists!'
    else
      createDatabase(dbName)

  $('#clearDbBtn').click ->
    # TODO: confirm
    clearDatabase()

  createDatabase = (dbName) ->
    $('#dbTabNav .active').removeClass 'active'
    $('#dbTabContent .active').removeClass 'active'
    $('#dbTabNav').append $('<li class="active"><a href="#' + dbName + 'Tab" data-toggle="tab">' + dbName + '</a></li>')
    $('#dbTabContent').append $('<div class="tab-pane active" id="' + dbName + 'Tab"></div>')
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
