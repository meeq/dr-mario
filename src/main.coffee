# Load the stylesheet chunk
require '../style/screen'
# Setup offline support
(require 'offline-plugin/runtime').install()
# Create the game
App = require './app'
app = new App
app.start()
