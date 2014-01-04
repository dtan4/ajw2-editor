window.app = angular.module 'ajw2Editor', ['ngStorage']

app.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=_csrf]').attr('content')
]
