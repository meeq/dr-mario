Cell = require './cell'
Direction = require './direction'

module.exports = class Matrix
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
  get: (x, y) ->
    @cells[x + (y * @width)] | 0
  set: (x, y, value) ->
    @cells[x + (y * @width)] = value | 0
  clear: (x, y) ->
    if x? and y?
      return @set x, y, Cell.EMPTY
    else
      @cells[i] = Cell.EMPTY for cell, i in @cells
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
      break if cellColor isnt Cell.getColor testCell
      break if Cell.isMarked testCell
      (@mark testX, originY) if (Direction.isX markDirections)
      leftMatches += 1
      testX -= 1
    # Horizontal Right
    testX = originX + 1
    rightMatches = 0
    while testX < @width
      testCell = @get testX, originY
      break if cellColor isnt Cell.getColor testCell
      break if Cell.isMarked testCell
      (@mark testX, originY) if (Direction.isX markDirections)
      rightMatches += 1
      testX += 1
    # Vertical Up
    testY = originY - 1
    upMatches = 0
    while testY >= 0
      testCell = @get originX, testY
      break if cellColor isnt Cell.getColor testCell
      break if Cell.isMarked testCell
      (@mark originX, testY) if (Direction.isY markDirections)
      upMatches += 1
      testY -= 1
    # Vertical Down
    testY = originY + 1
    downMatches = 0
    while testY < @height
      testCell = @get originX, testY
      break if cellColor isnt Cell.getColor testCell
      break if Cell.isMarked testCell
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
  isFalling: (originX, originY, checkDirection = true) ->
    cell = @get originX, originY
    if (originY >= @height - 1) or (Cell.isEmpty cell) or (Cell.isVirus cell)
      false
    else if (Cell.isEmpty (@get originX, originY + 1))
      if checkDirection and (directions = Cell.getDirection cell)
        isFalling = true
        for i in [0...Direction.numDirections directions]
          direction = Direction.directionAt directions, i
          # The cell above origin can't have an empty cell below it; skip it.
          continue if direction is Direction.UP
          coordinates = Direction.coordinates originX, originY, direction
          # Unpack the 32-bit result into 2 16-bit integers
          neighborX = coordinates >>> 16
          neighborY = coordinates & 0xFFFF
          isFalling = isFalling and @isFalling neighborX, neighborY, false
        isFalling
      else
        true
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
          cell = @get x, y
          @drop x, y
          totalDropped += 1
          # If the cell has a directional neighbor, drop it too.
          if (direction = Cell.getDirection cell)
            # TODO Handle HORIZ and VERT directions (probably recursively)
            coordinates = Direction.coordinates x, y, direction
            # Unpack the 32-bit result into 2 16-bit integers
            neighborX = coordinates >>> 16
            neighborY = coordinates & 0xFFFF
            if neighborX isnt x or neighborY isnt y
              @drop neighborX, neighborY
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
    newDirection = directions = Cell.getDirection cell
    for i in [0...Direction.numDirections directions]
      # TODO Handle long HORIZ and VERT directions (probably recursively)
      direction = Direction.directionAt directions, i
      coordinates = Direction.coordinates x, y, direction
      # Unpack the 32-bit result into 2 16-bit integers
      neighborX = coordinates >>> 16
      neighborY = coordinates & 0xFFFF
      if (Cell.isEmpty @get neighborX, neighborY)
        newDirection = Direction.unset newDirection, direction
    if newDirection isnt directions
      @set x, y, Cell.setDirection cell, newDirection
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
          # Re-shape directional neighbor(s)
          directions = Cell.getDirection cell
          for i in [0...Direction.numDirections directions]
            direction = Direction.directionAt directions, i
            coordinates = Direction.coordinates x, y, direction
            # Unpack the 32-bit result into 2 16-bit integers
            neighborX = coordinates >>> 16
            neighborY = coordinates & 0xFFFF
            @reshape neighborX, neighborY
    # Pack the number of viruses and cells cleared into a single 32-bit integer
    ((totalViruses & 0xFFFF) << 16) | (totalCleared & 0xFFFF)
