module.exports = class Setup
  template: require './templates/setup'
  constructor: ({@players}) ->
    return
  render: ->
    @el = document.createElement 'div'
    @el.id = 'setup'
    @el.innerHTML = @template()
    # TODO Control inputs, events
    @el
  destroy: ->
    @el?.parentNode?.removeChild @el
    delete @el
    return
