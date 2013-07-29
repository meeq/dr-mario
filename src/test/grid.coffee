Cell = require './cell'
Direction = require './direction'

module.exports = class Grid
  supportsTypedArrays: window.ArrayBuffer? and window.Uint8ClampedArray?
  constructor: (options) ->
    {@width, @height, @lineLength} = options
    numCells = @width * @height
    if @supportsTypedArrays
      cellBuffer = new ArrayBuffer numCells
      @cells = new Uint8ClampedArray cellBuffer
    else
      @cells = []
      @cells.length = numCells
    return
  get: (x, y) -> @cells[x + (y * @width)] | 0
  set: (x, y, value) -> @cells[x + (y * @width)] = value | 0
  clear: (x, y) ->
    if x? and y?
      return @set x, y, 0
    else
      @cells[i] = 0 for cell, i in @cells
      return
  isClear: (x, y) ->
    if x? and y?
      Cell.isEmpty @get x, y
    else
      # Walk through the grid left-to-right, bottom-up
      for x in [0...@width]
        for y in [@height - 1..0]
          return false if not Cell.isEmpty @get x, y
      true
  mark: (x, y) -> @set x, y, (Cell.setMark @get x, y)
  checkLineDirections: (originX, originY, markDirections = Direction.NONE) ->
    cell = @get originX, originY
    cellColor = Cell.getColor cell
    if not cellColor or (@isFalling originX, originY) or Cell.isMarked cell
      return false
    (@mark originX, originY) if markDirections
    # Horizontal Left
    testX = originX - 1
    leftMatches = 0
    while testX >= 0
      testCell = @get testX, originY
      break if (Cell.getColor testCell) isnt cellColor or Cell.isMarked testCell
      (@mark testX, originY) if (Direction.isX markDirections)
      leftMatches += 1
      testX -= 1
    # Horizontal Right
    testX = originX + 1
    rightMatches = 0
    while testX < @width
      testCell = @get testX, originY
      break if (Cell.getColor testCell) isnt cellColor or Cell.isMarked testCell
      (@mark testX, originY) if (Direction.isX markDirections)
      rightMatches += 1
      testX += 1
    # Vertical Up
    testY = originY - 1
    upMatches = 0
    while testY >= 0
      testCell = @get testX, originY
      break if (Cell.getColor testCell) isnt cellColor or Cell.isMarked testCell
      (@mark originX, testY) if (Direction.isY markDirections)
      upMatches += 1
      testY -= 1
    # Vertical Down
    testY = originY + 1
    downMatches = 0
    while testY < @height
      testCell = @get testX, originY
      break if (Cell.getColor testCell) isnt cellColor or Cell.isMarked testCell
      (@mark originX, testY) if (Direction.isY markDirections)
      downMatches += 1
      testY += 1
    # Determine line type(s) from directional match chains
    isHorizontalLine = 1 + leftMatches + rightMatches >= @lineLength
    isVerticalLine = 1 + upMatches + downMatches >= @lineLength
    if isHorizontalLine and isVerticalLine then Direction.CROSS
    else if isHorizontalLine then Direction.HORIZ
    else if isVerticalLine then Direction.VERT
    else Direction.NONE
  isFalling: (originX, originY, checkDirection = true, recurseBelow = false) ->
    cell = @get originX, originY
    if (originY >= @height - 1) or (Cell.isEmpty cell) or (Cell.isVirus cell)
      false
    else if (Cell.isEmpty (@get originX, originY + 1))
      if checkDirection and (direction = Cell.getDirection cell)
        coordinates = Direction.coordinates originX, originY, direction
        # Unpack the 32-bit result into 2 16-bit integers
        directionX = coordinates >>> 16
        directionY = coordinates & 0xFFFF
        @isFalling directionX, directionY, false
      else
        true
    else if recurseBelow # Unused, but possibly useful
      @isFalling originX, originY + 1
    else
      false
  drop: (x, y) ->
    cell = @get x, y
    @clear x, y
    @set x, y + 1, cell
    return
  dropFalling: ->
    totalDropped = 0
    # Walk through the grid left-to-right, bottom-up
    for x in [0...@width]
      # Skip the bottom row, since it can never have falling cells
      for y in [@height - 2..0]
        if @isFalling x, y
          @drop x, y
          totalDropped += 1
          # If the cell has a direction, drop it too.
          if (direction = Cell.getDirection cell)
            # TODO Handle HORIZ and VERT directions (probably recursively)
            coordinates = Direction.coordinates x, y, direction
            # Unpack the 32-bit result into 2 16-bit integers
            directionX = coordinates >>> 16
            directionY = coordinates & 0xFFFF
            if directionX isnt x or directionY isnt y
              @drop directionX, directionY
              totalDropped += 1
    totalDropped
  markLines: ->
    totalMarked = 0
    # Walk through through the grid left-to-right, top-down
    for x in [0...@width]
      for y in [0...@height]
        if (lines = @checkLineDirections x, y)
          @checkLineDirections x, y, lines
          totalMarked += Direction.numLines lines
    totalMarked
  reshape: (x, y) ->
    cell = @get x, y
    directions = Cell.getDirection cell
    for i in [0...Direction.numDirections directions]
      direction = Direction.directionAt directions, i
      coordinates = Direction.coordinates x, y, direction
      # Unpack the 32-bit result into 2 16-bit integers
      directionX = coordinates >>> 16
      directionY = coordinates & 0xFFFF
      unless neighborCell = @get directionX, directionY
        # TODO Handle HORIZ and VERT directions
        newDirection = Direction.NONE
    @set x, y, Cell.setDirection cell, newDirection if newDirection
    return
  clearMarked: ->
    totalCleared = 0
    totalViruses = 0
    # Walk through through the grid left-to-right, top-down
    for x in [0...@width]
      for y in [0...@height]
        cell = @get x, y
        if Cell.isMarked cell
          @clear x, y
          totalCleared += 1
          totalViruses += 1 if Cell.isVirus cell
          # Re-shape neighbor(s)
          directions = Cell.getDirection cell
          for i in [0...Direction.numDirections directions]
            direction = Direction.directionAt directions, i
            coordinates = Direction.coordinates x, y, direction
            # Unpack the 32-bit result into 2 16-bit integers
            directionX = coordinates >>> 16
            directionY = coordinates & 0xFFFF
            @grid.reshape directionX, directionY
    # Pack the number of viruses and cells cleared into a single 32-bit integer
    ((totalViruses & 0xFFFF) << 16) | (totalCleared & 0xFFFF)
