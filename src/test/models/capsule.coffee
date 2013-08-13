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
    @rotateBuffer = new Grid @
    @nextBuffer = new Grid @
    return
  generate: ->
    @x = @startX
    @y = @startY
    if @nextBuffer.isClear()
      @random @fallingBuffer
    else
      @blit @nextBuffer, @fallingBuffer
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
  isOutOfBounds: ->
    @y < (-@size + 1)
  drop: ->
    if not @isLanded()
      @y += 1
      if @isLanded()
        @landedTick = @game.ticks
      else
        delete @landedTick
    return
  applyInput: (input) ->
    return if @fallingBuffer.isClear() or PlayerInput.isNone input
    if PlayerInput.get input, PlayerInput.MOVE_LEFT
      @move Direction.LEFT
    if PlayerInput.get input, PlayerInput.MOVE_RIGHT
      @move Direction.RIGHT
    if PlayerInput.get input, PlayerInput.FLIP_LEFT
      @rotate Direction.LEFT
    if PlayerInput.get input, PlayerInput.FLIP_RIGHT
      @rotate Direction.RIGHT
    if PlayerInput.get input, PlayerInput.FAST_DROP
      @drop()
    if PlayerInput.get input, PlayerInput.INSTANT_DROP
      @drop() while not @isLanded()
    if PlayerInput.get input, PlayerInput.SWAP_HOLD
      @swapHold()
    return
  move: (direction) ->
    switch direction
      when Direction.LEFT
        newX = @x - 1
      when Direction.RIGHT
        newX = @x + 1
    @x = newX if newX? and not @checkCollision newX, @y
    return
  rotate: (direction) ->
    @flip @fallingBuffer, direction
    if @checkCollision()
      @flip @fallingBuffer, Direction.reverse direction
    return
  swapHold: ->
    swapBuffer = @fallingBuffer
    @fallingBuffer = @holdBuffer
    @holdBuffer = swapBuffer
    @x = @startX
    @y = @startY
    return
  writeToGrid: ->
    @blit @fallingBuffer, @grid, @x, @y
    @fallingBuffer.clear()
    return
  blit: (source, dest, destOffsetX = 0, destOffsetY = 0) ->
    # Copy the non-empty cells of source to dest
    for x in [0...@size]
      for y in [0...@size]
        unless (Cell.isEmpty cell = source.get x, y)
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
  flip: (buffer, direction) ->
    dim = @size - 1
    switch direction
      when Direction.LEFT
        for x in [0..dim]
          for y in [0..dim]
            @rotateBuffer.set x, y, buffer.get dim - y, x
      when Direction.RIGHT
        for x in [0..dim]
          for y in [0..dim]
            @rotateBuffer.set x, y, buffer.get y, dim - x
    buffer.clear()
    @blit @rotateBuffer, buffer
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
    # Push horizontal capsules to the bottom of the buffer
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
        # Treat grid boundaries (except top) as collisions
        return true if gridX < 0 or gridX >= @grid.width
        return true if gridY >= @grid.height
        gridCell = @grid.get gridX, gridY
        return true unless Cell.isEmpty gridCell
    return false
