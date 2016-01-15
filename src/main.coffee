# Load the stylesheet chunk
require.ensure [], ->
  require '../style/screen'
, "style"
# Create the game
App = require './app'
app = new App
app.start()
