Cell = require './cell'
Direction = require './direction'
Grid = require './grid'

module.exports = class Capsule
  constructor: (game) ->
    {@grid} = game
    @width = @height = game.capsuleSize
    @startX = (game.width / 2) - (@width / 2) | 0
    @startY = -@height
    @fallingBuffer = new Grid @
    @nextBuffer = new Grid @
    return
  isFalling: ->
    not @fallingBuffer.isClear()
  isLanded: ->
  isOutsideGrid: ->
  generate: ->
    @x = @startX
    @y = @startY
    if @nextBuffer.isClear()
      @random @fallingBuffer
    else
      @copy @nextBuffer, @fallingBuffer
    @random @nextBuffer
    return
  drop: ->
  applyInput: (input) ->
  writeToGrid: ->
  copy: (source, dest, destOffsetX = 0, destOffsetY = 0, copyEmpty = false) ->
    for x in [0...@width]
      for y in [0...@height]
        cell = source.get x, y
        if (not copyEmpty and cell) or copyEmpty
          dest.set destOffsetX + x, destOffsetY + y, cell
    return
  random: (buffer = @nextBuffer) ->
    for x in [0...@width]
      for y in [0...@height]
        # Clear everything except the bottom row
        if y < @height - 1
          buffer.clear x, y
        else
          # Randomly colored cells across the whole row facing each other.
          switch x
            when 0          then direction = Direction.RIGHT
            when @width - 1 then direction = Direction.LEFT
            else                 direction = Direction.HORIZ
          cell = Cell.setDirection Cell.randomColor(), direction
          buffer.set x, y, cell
    return
  flip: (buffer = @fallingBuffer, direction = Direction.RIGHT) ->
    numCells = @width * @height
    switch direction
      when Direction.RIGHT
        # Rotate the square 1-dimensional array clockwise
        for x in [0...numCells - 1]
          for y in [x + 1...numCells]
            temp = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, temp
      when Direction.LEFT
        # Rotate the square 1-dimensional array counter-clockwise
        for x in [numCells - 2..0]
          for y in [numCells - 1..x + 1]
            temp = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, temp
    return
  checkCollision: (originX = @x, originY = @y) ->
    for x in [0...@width]
      for y in [0...@height]
        capsuleCell = @fallingBuffer.get x, y
        continue if Cell.isEmpty capsuleCell
        gridCell = @grid.get originX + x, originY + y
        return false unless Cell.isEmpty gridCell
    return true
