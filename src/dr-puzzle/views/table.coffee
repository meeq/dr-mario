Cell = require '../models/cell'
Direction = require '../models/direction'
Timer = require '../models/timer'

getCellClassName = (cell) ->
  if Cell.isEmpty cell
    className = 'empty'
  else
    className = Cell.getColorName cell
    if Cell.isMarked cell
      className += ' marked'
    else if Cell.isVirus cell
      className += ' virus'
    else
      className += ' pill'
      direction = Cell.getDirection cell
      if      direction is Direction.UP    then className += ' up'
      else if direction is Direction.DOWN  then className += ' down'
      else if direction is Direction.LEFT  then className += ' left'
      else if direction is Direction.RIGHT then className += ' right'
  className

tickClassName = 'game-state tick'
tockClassName = 'game-state tock'

module.exports = class TableView
  lastTick: null
  tickRate: 250
  constructor: (@state) ->
    @lastTick = Timer.now()
    return
  render: ->
    @el = document.createElement 'table'
    @el.className = tickClassName
    @cellEls = []
    # Render playable grid
    for y in [0...@state.height]
      tr = document.createElement 'tr'
      for x in [0...@state.width]
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
    now = Timer.now()
    # Update animations
    if @lastTick + @tickRate < now
      @lastTick = now
      if @el.className isnt tickClassName
        @el.className = tickClassName
      else
        @el.className = tockClassName
    # Update cell states
    for td in @cellEls
      x = td.dataset.x | 0
      y = td.dataset.y | 0
      cell = @state.capsule?.get x, y
      if Cell.isEmpty cell
        cell = @state.grid?.get x, y
      className = getCellClassName cell
      if td.className isnt className
        td.className = className
    return
