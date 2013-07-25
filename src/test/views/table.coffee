Cell = require '../cell'

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
        cell = @game.getCell x, y
        if cell
          className = Cell.getColorName(cell)
          if Cell.isVirus(cell)
            className += ' virus'
        else
          className = ''
        if td.className isnt className
          td.className = className
    return
