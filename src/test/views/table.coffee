Cell = require '../models/cell'
Direction = require '../models/direction'

getCellClassName = (cell) ->
  return 'empty' unless cell?
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
  constructor: (@game) ->
    return
  render: ->
    @el = document.createElement 'table'
    for y in [0...@game.height]
      tr = document.createElement 'tr'
      for x in [0...@game.width]
        td = document.createElement 'td'
        td.title = "#{x}, #{y}"
        tr.appendChild td
      @el.appendChild tr
    @lastTick = @game.ticks
    @update()
    @el
  destroy: ->
    if @el?
      if @el.parentNode?
        @el.parentNode.removeChild @el
      @el = null
    return
  update: ->
    if @lastTick < @game.ticks
      @lastTick = @game.ticks
      if @lastTick % 6 >= 3
        @el.className = "tick"
      else
        @el.className = "tock"
    for tr, y in @el.childNodes
      for td, x in tr.childNodes
        cell = @game.grid?.get x, y
        if Cell.isEmpty cell
          cell = @game.capsule?.get x, y
        className = getCellClassName cell
        if td.className isnt className
          td.className = className
    return
