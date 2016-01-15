
App = require './app'
app = new App
app.start()

require.ensure [], ->
  require '../style/screen'
, "style"
