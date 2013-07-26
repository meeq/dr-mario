Cell = require './cell'
Line = require './line'

module.exports = class Grid
  constructor: (@game) ->
    {@width, @height, @lineLength} = @game
    numCells = @width * @height
    if @game.supportsTypedArrays
      console.log "Using TypedArray for maximum 8-bit power!"
      cellBuffer = new ArrayBuffer numCells
      @cells = new Uint8ClampedArray cellBuffer
    else
      console.log "Falling back to regular Array for maximum normal."
      @cells = []
      @cells.length = numCells
    return
  get: (x, y) -> @cells[x + (y * @width)] | 0
  getColor: (x, y) -> Cell.getColor (@get x, y)
  set: (x, y, value) -> @cells[x + (y * @width)] = value | 0
  clear: (x, y) -> @set x, y, 0
  isMarked: (x, y) -> Cell.isMarked @get x, y
  mark: (x, y) -> @set x, y, (Cell.setMark @get x, y)
  findLines: (originX, originY, markLines = Line.NONE) ->
    cellColor = @getColor originX, originY
    return false if not cellColor
    (@mark originX, originY) if markLines
    # Horizontal Left
    testX = originX - 1
    leftMatches = 0
    while testX >= 0 and (@getColor testX, originY) is cellColor
      (@mark testX, originY) if (Line.hasX markLines)
      leftMatches += 1
      testX -= 1
    # Horizontal Right
    testX = originX + 1
    rightMatches = 0
    while testX < @width and (@getColor testX, originY) is cellColor
      (@mark testX, originY) if (Line.hasX markLines)
      rightMatches += 1
      testX += 1
    # Vertical Up
    testY = originY - 1
    upMatches = 0
    while testY >= 0 and (@getColor originX, testY) is cellColor
      (@mark originX, testY) if (Line.hasY markLines)
      upMatches += 1
      testY -= 1
    # Vertical Down
    testY = originY + 1
    downMatches = 0
    while testY < @height and (@getColor originX, testY) is cellColor
      (@mark originX, testY) if (Line.hasY markLines)
      downMatches += 1
      testY += 1
    # Determine line type(s) from directional match chains
    isHorizontalLine = 1 + leftMatches + rightMatches >= @lineLength
    isVerticalLine = 1 + upMatches + downMatches >= @lineLength
    if isHorizontalLine and isVerticalLine then Line.XY
    else if isHorizontalLine then Line.X
    else if isVerticalLine then Line.Y
    else Line.NONE
  isOrphan: (originX, originY, checkMate = true) ->
    # TODO
    # If cell is virus or empty or on the bottom row, return false
    # If cell below is empty
      # If checkMate and cell is coupled and mate is orphan, return true
      # Else return false
    # If cell below is orphan, return true
    return false
  clearMarked: ->
    totalMarked = 0
    totalViruses = 0
    # Walk through through the grid
    for x in [0...@width]
      for y in [0...@height]
        cell = @get x, y
        if Cell.isMarked cell
          totalMarked += 1
          totalViruses += 1 if Cell.isVirus cell
          @clear x, y
    # Pack the number of viruses and cells cleared into a single 32-bit integer
    ((totalViruses & 0xFFFF) << 16) | (totalMarked & 0xFFFF)
