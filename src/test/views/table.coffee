Cell = require '../cell'
Direction = require '../direction'

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
  constructor: (@game) ->
    return
  render: ->
    @el = document.createElement 'table'
    for y in [0...@game.height]
      tr = document.createElement 'tr'
      for x in [0...@game.width]
        td = document.createElement 'td'
        text = document.createTextNode "#{x}, #{y}"
        td.appendChild text
        tr.appendChild td
      @el.appendChild tr
    @tick()
    @el
  destroy: ->
    if @el?
      if @el.parentNode?
        @el.parentNode.removeChild @el
      @el = null
    return
  tick: ->
    for tr, y in @el.childNodes
      for td, x in tr.childNodes
        cell = @game.grid.get x, y
        if Cell.isEmpty cell
          cell = @game.capsule.get x, y
        className = getCellClassName cell
        if td.className isnt className
          td.className = className
    return
