Cell = require './cell'
Mate = require './mate'
Grid = require './grid'

Direction =
  LEFT: 0
  RIGHT: 1
  reverse: (direction) -> ~direction

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
            when 0          then mate = Mate.RIGHT
            when @width - 1 then mate = Mate.LEFT
            else                 mate = Mate.HORIZ
          cell = Cell.setMate Cell.randomColor(), mate
          buffer.set x, y, cell
    return
  flip: (buffer = @frontBuffer, direction = Direction.RIGHT) ->
    switch direction
      when Direction.RIGHT
        for x in [0...@width - 1]
          for y in [x + 1...@width]
            temp = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, temp
      when Direction.LEFT
        for x in [@width - 2..0]
          for y in [@width - 1..x + 1]
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




