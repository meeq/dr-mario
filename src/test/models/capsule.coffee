Cell = require './cell'
Direction = require './direction'
Grid = require './grid'
PlayerInput = require './player-input'

module.exports = class Capsule
  constructor: (@game) ->
    {@grid} = @game
    @width = @height = @game.capsuleSize
    @x = @startX = (@game.width / 2) - (@width / 2) | 0
    @y = @startY = -@height
    @fallingBuffer = new Grid @
    @nextBuffer = new Grid @
    return
  generate: ->
    @x = @startX
    @y = @startY
    if @nextBuffer.isClear()
      @random @fallingBuffer
    else
      @copy @nextBuffer, @fallingBuffer
    @random @nextBuffer
    return
  get: (x, y) ->
    isInX = x >= @x and x < (@x + @width)
    isInY = y >= @y and y < (@y + @height)
    if isInX and isInY
      @fallingBuffer.get x - @x, y - @y
    else
      Cell.EMPTY
  isFalling: ->
    not @fallingBuffer.isClear()
  isLanded: ->
    if @y >= @game.height - 1
      true
    else
      @checkCollision @x, @y + 1
  isOutsideGrid: ->
    @y < (-@height + 1)
  drop: ->
    @y += 1 if not @isLanded()
    return
  applyInput: (input) ->
    return if PlayerInput.isNone input
    if PlayerInput.get input, PlayerInput.MOVE_LEFT
      @move @fallingBuffer, Direction.LEFT
    if PlayerInput.get input, PlayerInput.MOVE_RIGHT
      @move @fallingBuffer, Direction.RIGHT
    if PlayerInput.get input, PlayerInput.FLIP_LEFT
      @flip @fallingBuffer, Direction.LEFT
    if PlayerInput.get input, PlayerInput.FLIP_RIGHT
      @flip @fallingBuffer, Direction.RIGHT
    if PlayerInput.get input, PlayerInput.FAST_DROP
      @drop()
    if PlayerInput.get input, PlayerInput.INSTANT_DROP
      @drop() while not @isLanded()
    return
  writeToGrid: ->
    @copy @fallingBuffer, @grid, @x, @y
    @fallingBuffer.clear()
    return
  copy: (source, dest, destOffsetX = 0, destOffsetY = 0, copyEmpty = false) ->
    for x in [0...@width]
      for y in [0...@height]
        cell = source.get x, y
        if (not copyEmpty and cell) or copyEmpty
          dest.set destOffsetX + x, destOffsetY + y, cell
    return
  random: (buffer = @nextBuffer) ->
    numColors = @game.numColors
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
          cell = Cell.setDirection (Cell.randomColor numColors), direction
          buffer.set x, y, cell
    return
  move: (buffer, direction) ->
    # TODO
  flip: (buffer, direction) ->
    # TODO
    numCells = @width * @height
    switch direction
      when Direction.RIGHT
        # Rotate the square 1-dimensional array clockwise
        for x in [0...numCells - 1]
          for y in [x + 1...numCells]
            cell = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, cell
      when Direction.LEFT
        # Rotate the square 1-dimensional array counter-clockwise
        for x in [numCells - 2..0]
          for y in [numCells - 1..x + 1]
            cell = buffer.get x, y
            buffer.set x, y, buffer.get y, x
            buffer.set y, x, cell
    # Rotate the directions of the cells
    for x in [0...@width]
      for y in [0...@height]
        cell = buffer.get x, y
        cellDirection = Cell.getDirection cell
        rotatedDirection = Direction.rotate cellDirection, direction
        cell = Cell.setDirection rotatedDirection
        buffer.set x, y, cell
    return
  checkCollision: (originX = @x, originY = @y) ->
    for x in [0...@width]
      for y in [0...@height]
        capsuleCell = @fallingBuffer.get x, y
        continue if Cell.isEmpty capsuleCell
        gridCell = @grid.get originX + x, originY + y
        return true unless Cell.isEmpty gridCell
    return false
