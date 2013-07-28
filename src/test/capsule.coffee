Cell = require './cell'
Direction = require './direction'
Grid = require './grid'

module.exports = class Capsule
  constructor: (game) ->
    {@grid} = game
    @width = @height = 2
    @startX = (game.width / 2) - (@width / 2) | 0
    @x = @startX
    @y = 0
    @frontBuffer = new Grid @
    @backBuffer = new Grid @
    return
  isFalling: ->
    not @frontBuffer.isClear()
  generate: ->
    if @backBuffer.isClear()
      @random @frontBuffer
    else
      @copy @backBuffer, @frontBuffer
    @random @backBuffer
    return
  copy: (source, dest, destOffsetX = 0, destOffsetY = 0) ->
    for x in [0...@width]
      for y in [0...@height]
        dest.set x + destOffsetX, y + destOffsetY, source.get x, y
    return
  random: (buffer = @backBuffer) ->
    for x in [0...@width]
      for y in [0...@height]
        if y < @height - 1
          buffer.clear x, y
        else
          switch x
            when 0          then direction = Direction.RIGHT
            when @width - 1 then direction = Direction.LEFT
            else                 direction = Direction.HORIZ
          cell = Cell.setDirection Cell.randomColor(), direction
          buffer.set x, y, cell
    return
  flip: (buffer = @frontBuffer, direction = Direction.RIGHT) ->
    numCells = @width * @height
    switch direction
      when Direction.RIGHT
        for x in [0...@numCells - 1]
          for y in [x + 1...@numCells]
            temp = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, temp
      when Direction.LEFT
        for x in [@numCells - 2..0]
          for y in [@numCells - 1..x + 1]
            temp = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, temp
    return
  checkCollision: (originX = @x, originY = @y) ->
    for x in [0...@width]
      for y in [0...@height]
        capsuleCell = @frontBuffer.get x, y
        continue if Cell.isEmpty capsuleCell
        gridCell = @grid.get originX + x, originY + y
        return false unless Cell.isEmpty gridCell
    return true




