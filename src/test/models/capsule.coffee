Cell = require './cell'
Direction = require './direction'
Grid = require './grid'
PlayerInput = require './player-input'

module.exports = class Capsule
  constructor: (@game) ->
    {@grid} = @game
    @width = @height = @size = @game.capsuleSize
    @x = @startX = Math.round (@game.width / 2) - (@size / 2)
    @y = @startY = -@size
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
    isInX = x >= @x and x < (@x + @size)
    isInY = y >= @y and y < (@y + @size)
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
    @y < (-@size + 1)
  drop: ->
    @y += 1 if not @isLanded()
    return
  applyInput: (input = PlayerInput.NONE) ->
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
    for x in [0...@size]
      for y in [0...@size]
        cell = source.get x, y
        if (not copyEmpty and cell) or copyEmpty
          dest.set destOffsetX + x, destOffsetY + y, cell
    return
  random: (buffer = @nextBuffer) ->
    numColors = @game.numColors
    for x in [0...@size]
      for y in [0...@size]
        # Clear everything except the bottom row
        if y < @size - 1
          buffer.clear x, y
        else
          # Randomly colored cells across the whole row facing each other.
          switch x
            when 0          then direction = Direction.RIGHT
            when @size - 1  then direction = Direction.LEFT
            else                 direction = Direction.HORIZ
          cell = Cell.setDirection (Cell.randomColor numColors), direction
          buffer.set x, y, cell
    return
  move: (buffer, direction) ->
    switch direction
      when Direction.LEFT
        newX = @x - 1
      when Direction.RIGHT
        newX = @x + 1
    @x = newX if newX? and not @checkCollision newX, @y
    return
  flip: (buffer, direction) ->
    dim = @size - 1
    floor = Math.floor @size / 2
    ceil = Math.ceil @size / 2
    switch direction
      when Direction.LEFT
        # Rotate the square matrix counter-clockwise in-place
        for x in [floor - 1..0]
          for y in [ceil - 1..0]
            tx = dim - x
            ty = dim - y
            temp1 = buffer.get x, y
            temp2 = buffer.get y, tx
            temp3 = buffer.get tx, ty
            temp4 = buffer.get ty, x
            buffer.set x, y, temp4
            buffer.set y, tx, temp1
            buffer.set tx, ty, temp2
            buffer.set ty, x, temp3
      when Direction.RIGHT
        # Rotate the square matrix clockwise in-place
        for x in [0...floor]
          for y in [0...ceil]
            tx = dim - x
            ty = dim - y
            temp1 = buffer.get x, y
            temp2 = buffer.get y, tx
            temp3 = buffer.get tx, ty
            temp4 = buffer.get ty, x
            buffer.set x, y, temp2
            buffer.set y, tx, temp3
            buffer.set tx, ty, temp4
            buffer.set ty, x, temp1
    rowY = null
    isRow = false
    for y in [0..dim]
      for x in [0..dim]
        cell = buffer.get x, y
        isEmpty = Cell.isEmpty cell
        # Determine if the capsule is horizontal and which row it is on.
        isRow = true if x is 0
        isRow = isRow and not isEmpty
        rowY = y if x is dim and isRow
        continue if isEmpty
        # Rotate the directions of the cells
        cellDirection = Cell.getDirection cell
        rotatedDirection = Direction.rotate cellDirection, direction
        rotatedCell = Cell.setDirection cell, rotatedDirection
        buffer.set x, y, rotatedCell
    # Ensure that a horizontal capsule is always at the bottom of its buffer
    if rowY?
      for x in [0..dim]
        cell = buffer.get x, rowY
        buffer.clear x, rowY
        buffer.set x, dim, cell
    return
  checkCollision: (originX = @x, originY = @y) ->
    for x in [0...@size]
      for y in [0...@size]
        capsuleCell = @fallingBuffer.get x, y
        continue if Cell.isEmpty capsuleCell
        gridX = originX + x
        gridY = originY + y
        return true if gridX < 0 or gridX >= @grid.width
        return true if gridY >= @grid.height
        gridCell = @grid.get gridX, gridY
        return true unless Cell.isEmpty gridCell
    return false
