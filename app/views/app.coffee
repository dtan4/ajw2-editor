$ ->
    $('#createBtn').click ->
        alert 'Create New!'

    $('#saveBtn').click ->
        alert 'Save!'

    $('#generateBtn').click ->
        alert 'Generate!'

    $('#createDbBtn').click ->
        if $('#newDbName').val() is ''
            alert 'Database name is empty!'
        else
            createDatabase($('#newDbName').val())
            $('#createDbModal').modal('hide')

    createDatabase = (dbName) ->
        alert 'created!'
        # $('<div class="tab-pane" id="' + dbName + 'Tab"></div>').prependTo $('#newDbContent')
        # $('<li><a href="#' + dbName + 'Tab" data-toggle="tab">' + dbName + '</a></li>').prependTo $('#dbTabNav')
        # $('#dbTabContent a:last').tab('show')
