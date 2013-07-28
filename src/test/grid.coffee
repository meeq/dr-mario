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
  getColor: (x, y) -> Cell.getColor (@get x, y)
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
  isMarked: (x, y) -> Cell.isMarked @get x, y
  mark: (x, y) -> @set x, y, (Cell.setMark @get x, y)
  checkLineDirections: (originX, originY, markDirections = Direction.NONE) ->
    cellColor = @getColor originX, originY
    return false if not cellColor or (@isFalling originX, originY)
    (@mark originX, originY) if markDirections
    # Horizontal Left
    testX = originX - 1
    leftMatches = 0
    while testX >= 0 and (@getColor testX, originY) is cellColor
      (@mark testX, originY) if (Direction.isX markDirections)
      leftMatches += 1
      testX -= 1
    # Horizontal Right
    testX = originX + 1
    rightMatches = 0
    while testX < @width and (@getColor testX, originY) is cellColor
      (@mark testX, originY) if (Direction.isX markDirections)
      rightMatches += 1
      testX += 1
    # Vertical Up
    testY = originY - 1
    upMatches = 0
    while testY >= 0 and (@getColor originX, testY) is cellColor
      (@mark originX, testY) if (Direction.isY markDirections)
      upMatches += 1
      testY -= 1
    # Vertical Down
    testY = originY + 1
    downMatches = 0
    while testY < @height and (@getColor originX, testY) is cellColor
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
  dropFalling: ->
    totalDropped = 0
    # Walk through the grid left-to-right, bottom-up
    for x in [0...@width]
      # Skip the bottom row, since it can never have falling cells
      for y in [@height - 2..0]
        if @isFalling x, y
          cell = @get x, y
          @clear x, y
          @set x, y + 1, cell
          totalDropped += 1
          # If the cell has a direction, drop it too.
          if (direction = Cell.getDirection cell)
            coordinates = Direction.coordinates x, y, direction
            # Unpack the 32-bit result into 2 16-bit integers
            directionX = coordinates >>> 16
            directionY = coordinates & 0xFFFF
            directionCell = @get directionX, directionY
            @clear directionX, directionY
            @set directionX, directionY + 1, directionCell
            totalDropped += 1
            # Mark the cells if they have created lines by dropping
            if (lines = @checkLineDirections directionX, directionY + 1)
              @checkLineDirections directionX, directionY, lines
          # Mark the cells if they have created lines by dropping
          if (lines = @checkLineDirections x, y + 1)
            @checkLineDirections x, y + 1, lines
    totalDropped
  clearMarked: ->
    totalMarked = 0
    totalViruses = 0
    # Walk through through the grid left-to-right, top-down
    for x in [0...@width]
      for y in [0...@height]
        cell = @get x, y
        if Cell.isMarked cell
          totalMarked += 1
          totalViruses += 1 if Cell.isVirus cell
          @clear x, y
    # Pack the number of viruses and cells cleared into a single 32-bit integer
    ((totalViruses & 0xFFFF) << 16) | (totalMarked & 0xFFFF)
