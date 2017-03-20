Speed = require '../models/speed'

module.exports = class PlayerScoreboardView
  fields: ['score', 'virus', 'level', 'speed']
  constructor: ({@state}) ->
    return
  render: ->
    @el = document.createElement 'dl'
    @el.className = 'player-scoreboard'
    for field in @fields
      keyElem = document.createElement 'dt'
      keyElem.innerText = field
      @el.appendChild keyElem
      valueElem = document.createElement 'dd'
      @el.appendChild valueElem
      @[field + 'Elem'] = valueElem
    @el
  destroy: ->
    for field in @fields
      delete @[field + 'Elem']
    # Clean up the DOM
    @el?.parentNode?.removeChild @el
    delete @el
    return
  update: ->
    @scoreElem.innerText = "#{@state.score}"
    @virusElem.innerText = "#{@state.virusesLeft}"
    @levelElem.innerText = "#{@state.level}"
    @speedElem.innerText = Speed.options[@state.speed]
    return
