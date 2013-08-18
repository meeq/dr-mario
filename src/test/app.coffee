Setup = require './setup'

module.exports = class TestApp
  start: ->
    setup = new Setup
    wrapper = document.getElementById 'wrap'
    wrapper.appendChild setup.render()
    return
