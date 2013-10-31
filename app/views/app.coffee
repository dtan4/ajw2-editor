$ ->
    console.log 'hoge'

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
            $('#createDbModal').modal('hide')
