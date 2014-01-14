app.directive 'fileOnChange', ->
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      onChangeFunc = element.scope()[attrs.fileOnChange]
      element.bind 'change', onChangeFunc
  }

app.controller 'NavbarCtrl', ($rootScope, $scope) ->
  $scope.createNew = ->
    $rootScope.$broadcast 'cleanup', {}

  $scope.openSourceFile = (evt) ->
    sourceFile = evt.target.files[0]

    unless sourceFile.type == 'application/json'
      console.error 'invalid file'

    reader = new FileReader()
    reader.onload = (file) ->
      source = JSON.parse file.target.result
      console.log source

    reader.readAsText(sourceFile)
