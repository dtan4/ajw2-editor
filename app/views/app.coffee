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
    if !dbName.match(/^[0-9a-zA-Z]+$/)
      alert 'Invalid database name!'
      return
    else
      $('#dbTabNav .active').removeClass 'active'
      $('#dbTabContent .active').removeClass 'active'
      $('#dbTabNav').append $('<li class="active"><a href="#' + dbName + 'Tab" data-toggle="tab">' + dbName + '</a></li>')
      newTabHTML = '''
  <div class="tab-pane active" id="#{dbName}Tab">
    <form class="form-inline" role="form" style="margin-top:10px">
      <div class="form-group">
        <label class="sr-only" for="#{dbName}newFieldName"></label>
        <input type="text" class="form-control" id="#{dbName}newFieldName" placeholder="Field name">
      </div>
      <div class="form-group">
        <label class="sr-only" for="#{dbName}newFieldType"></label>
        <input type="text" class="form-control" id="#{dbName}newFieldType" placeholder="Field Type" style="margin-left:10px">
      </div>
      <button type="button" class="btn btn-primary" id="#{dbName}newFieldBtn" style="margin-left:20px">Add field</button>
    </form>
    <table class="table table-striped">
      <thead>
        <tr>
          <th>Field name</th>
          <th>Field type</th>
        </tr>
      </thead>
      <tbody id="#{dbName}table">
      </tbody>
    </table>
  </div>
  '''
      $('#' + dbName + 'newFieldBtn').bind('click',
        addNewField(dbName, $('#' + dbName + 'newFieldName').val(), $('#' + dbName + 'newFieldType').val()))
      $('#dbTabContent').html(newTabHTML)
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

  addNewField = (db, fieldName, fieldType) ->
    console.log db, fieldName, fieldType
