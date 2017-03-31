Cell = require '../models/cell'

module.exports = class PlayerMatrixView
  constructor: ({@state, @buffer}) ->
    return
  render: ->
    @el = document.createElement 'table'
    @el.className = 'player-matrix'
    @cellEls = []
    {width, height} = @state ? @buffer
    # Render playable grid
    for y in [0...height]
      tr = document.createElement 'tr'
      for x in [0...width]
        tr.appendChild @renderCell x, y
      @el.appendChild tr
    @update()
    @el
  renderCell: (x, y) ->
    cellEl = document.createElement 'td'
    cellEl.dataset.x = x
    cellEl.dataset.y = y
    @cellEls?.push cellEl
    cellEl
  destroy: ->
    @el?.parentNode?.removeChild @el
    delete @cellEls
    delete @el
    return
  update: ->
    # Update cell states
    if @cellEls? then for td in @cellEls
      x = td.dataset.x | 0
      y = td.dataset.y | 0
      cell = Cell.EMPTY
      if @state?
        cell = @state.capsule?.get x, y
        if Cell.isEmpty cell
          cell = @state.grid?.get x, y
      else if @buffer?
        cell = @buffer.get x, y
      className = Cell.getClassName cell
      if td.className isnt className
        td.className = className
    return
