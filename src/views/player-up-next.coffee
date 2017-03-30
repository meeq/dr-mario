setter = (klass, prop, set) ->
  Object.defineProperty klass.prototype, prop, {set, configurable: true}

module.exports = class PlayerUpNextView
  setter @, 'state', (state) ->
    {capsule} = state
    {@nextBuffer} = capsule
    return
  constructor: (options) ->
    @state = options.state
    return
  render: ->
    @el = document.createElement 'aside'
    @el.className = 'player-up-next'
    @update()
    @el
  destroy: ->
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  update: ->
    return
