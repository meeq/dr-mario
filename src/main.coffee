# Setup offline support (Disabled)
(require 'offline-plugin/runtime').install()

# Load the stylesheet chunk
require '../style/screen'

# Create the game
App = require './app'
app = new App
app.start()
