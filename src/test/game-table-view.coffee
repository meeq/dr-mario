colors = require './colors'

module.exports = class GameTableView
  constructor: (@game) ->
    return
  render: ->
    @el = document.createElement 'table'
    for y in [0...@game.height]
      row = document.createElement 'tr'
      for x in [0...@game.width]
        cell = document.createElement 'td'
        row.appendChild cell
      @el.appendChild row
    @tick()
    @el
  tick: ->
    for row, y in @el.childNodes
      for cell, x in row.childNodes
        cellColor = @game.grid.getCell x, y
        if cellColor
          className = colors.colorNames[cellColor - 1]
          if @game.virusGrid.getCell x, y
            className += ' virus'
        else
          className = ''
        cell.className = className
    return
  destroy: ->
    if @el?
      if @el.parentNode?
        @el.parentNode.removeChild @el
      @el = null
    return
