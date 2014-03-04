window.app = angular.module 'ajw2Editor', ['ngStorage']

app.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=_csrf]').attr('content')
]

app.directive 'fileOnChange', ->
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      onChangeFunc = element.scope()[attrs.fileOnChange]
      element.bind 'change', onChangeFunc
  }
