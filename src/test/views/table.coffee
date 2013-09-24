Cell = require '../models/cell'
Direction = require '../models/direction'

getCellClassName = (cell) ->
  if Cell.isEmpty cell
    className = 'empty'
  else
    className = Cell.getColorName cell
    if Cell.isVirus cell
      className += ' virus'
    else
      className += ' pill'
    if Cell.isMarked cell
      className += ' marked'
    switch Cell.getDirection cell
      when Direction.UP    then className += ' up'
      when Direction.DOWN  then className += ' down'
      when Direction.LEFT  then className += ' left'
      when Direction.RIGHT then className += ' right'
  className

module.exports = class TableView
  lastTick: null
  tickRate: 250
  constructor: (@state) ->
    @lastTick = Date.now()
    return
  render: ->
    @el = document.createElement 'div'
    @el.className = 'game-state table'
    # Render borders behind table
    borderEl = document.createElement 'div'
    borderEl.className = 'border'
    @el.appendChild borderEl
    @tableEl = document.createElement 'table'
    @cellEls = []
    # Render the drop zone
    thead = document.createElement 'thead'
    for y in [-@state.capsuleSize...0]
      tr = document.createElement 'tr'
      for x in [0...@state.width]
        tr.appendChild @renderCell x, y
      thead.appendChild tr
    @tableEl.appendChild thead
    # Render playable grid
    tbody = document.createElement 'tbody'
    for y in [0...@state.height]
      tr = document.createElement 'tr'
      for x in [0...@state.width]
        tr.appendChild @renderCell x, y
      tbody.appendChild tr
    @tableEl.appendChild tbody
    @el.appendChild @tableEl
    @update()
    @el
  renderCell: (x, y) ->
    cellEl = document.createElement 'td'
    cellEl.dataset.x = x
    cellEl.dataset.y = y
    cellEl.title = "#{x}, #{y}"
    @cellEls?.push cellEl
    cellEl
  destroy: ->
    @el?.parentNode?.removeChild @el
    delete @el
    delete @cellEls
    return
  update: ->
    now = Date.now()
    # Update animations
    if @lastTick + @tickRate < now
      @lastTick = now
      if @tableEl.className isnt 'tick'
        @tableEl.className = 'tick'
      else
        @tableEl.className = 'tock'
    # Update cell states
    for td in @cellEls
      x = td.dataset.x | 0
      y = td.dataset.y | 0
      cell = @state.grid?.get x, y
      if Cell.isEmpty cell
        cell = @state.capsule?.get x, y
      className = getCellClassName cell
      if td.className isnt className
        td.className = className
    return
