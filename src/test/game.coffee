Cell = require './cell'
Line = require './line'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultMinLineLength = 4
defaultMaxYCeiling = 3
defaultLevelVirusMultiplier = 4

randomInRange = (start, end) ->
  start + (Math.floor Math.random() * (end - start))

module.exports = class Game
  constructor: (options = {}) ->
    @ticks = 0
    @width = options.width ? defaultWidth
    @height = options.height ? defaultHeight
    @speed = options.speed ? defaultSpeed
    @minLineLength = options.minLineLength ? defaultMinLineLength
    @maxYCeiling = options.maxYCeiling ? defaultMaxYCeiling
    @levelVirusMultiplier =
      options.levelVirusMultiplier ? defaultLevelVirusMultiplier
    level = options.level ? defaultLevel
    @resetToLevel level
  resetToLevel: (level) ->
    # Reset and redimension game grid
    numCells = @width * @height
    if window.ArrayBuffer? and window.Uint8ClampedArray?
      gridBuffer = new ArrayBuffer numCells
      @grid = new Uint8ClampedArray gridBuffer
    else
      @grid = []
      @grid.length = numCells
    # Create an index of available cells for viruses
    yCeiling = @height - level
    yCeiling = @maxYCeiling if yCeiling < @maxYCeiling
    topLeftOpenIndex = (yCeiling * @width)
    bottomRightOpenIndex = @width + ((@height - 1) * @width)
    openCellIndexes = [topLeftOpenIndex...bottomRightOpenIndex]
    # Randomly generate viruses on grid based on current level
    @virusesLeft = 0
    levelViruses = (@levelVirusMultiplier * level) + @levelVirusMultiplier
    while @virusesLeft < levelViruses and openCellIndexes.length
      randomOpenIndex = randomInRange 0, openCellIndexes.length
      cellIndex = openCellIndexes[randomOpenIndex]
      openCellIndexes.splice randomOpenIndex, 1
      # Convert random cell index back into coordinates
      x = (cellIndex % @width)
      y = (cellIndex / @width) | 0
      # Generate a randomly colored virus in cell that doesn't complete a line
      cellLineDir = Line.XY
      while cellLineDir isnt Line.NONE
        cell = Cell.setVirus Cell.randomColorIndex()
        @setCell x, y, cell
        cellLineDir = @getCellLineDirections x, y
      @virusesLeft += 1
    return
  getCell: (x, y) ->
    @grid[x + (y * @width)] | 0
  getCellColor: (x, y) ->
    Cell.getColorIndex (@getCell x, y)
  setCell: (x, y, value) ->
    @grid[x + (y * @width)] = value | 0
  markCell: (x, y) ->
    cell = @getCell x, y
    @setCell x, y, (Cell.setMark cell)
  getCellLineDirections: (originX, originY, markDirections = Line.NONE) ->
    cellColor = @getCellColor originX, originY
    return false if not cellColor
    (@markCell originX, originY) if markDirections
    # Horizontal Left
    testX = originX - 1
    leftMatches = 0
    while testX >= 0 and (@getCellColor testX, originY) is cellColor
      (@markCell testX, originY) if (Line.hasX markDirections)
      leftMatches += 1
      testX -= 1
    # Horizontal Right
    testX = originX + 1
    rightMatches = 0
    while testX < @width and (@getCellColor testX, originY) is cellColor
      (@markCell testX, originY) if (Line.hasX markDirections)
      rightMatches += 1
      testX += 1
    # Vertical Up
    testY = originY - 1
    upMatches = 0
    while testY >= 0 and (@getCellColor originX, testY) is cellColor
      (@markCell originX, testY) if (Line.hasY markDirections)
      upMatches += 1
      testY -= 1
    # Vertical Down
    testY = originY + 1
    downMatches = 0
    while testY < @height and (@getCellColor originX, testY) is cellColor
      (@markCell originX, testY) if (Line.hasY markDirections)
      downMatches += 1
      testY += 1
    # Determine line type(s) from directional match chains
    isVerticalLine = 1 + leftMatches + rightMatches >= @minLineLength
    isHorizontalLine = 1 + upMatches + downMatches >= @minLineLength
    if isVerticalLine and isHorizontalLine then Line.XY
    else if isVerticalLine then Line.Y
    else if isHorizontalLine then Line.X
    else Line.NONE
  isCellOrphaned: (originX, originY) ->
    # TODO This can't possibly work
    cell = @getCell originX, originY
    return false if (Cell.isVirus cell) or not (Cell.getColorIndex cell)
    # Horizontal Left
    x = originX - 1
    return false if x >= 0 and @getCellColor x, originY
    # Horizontal Right
    x = originX + 1
    return false if x < @width and @getCellColor x, originY
    # Vertical Up
    y = originY - 1
    return false if y >= 0 and @getCellColor originX, y
    # Vertical Down
    y = originY + 1
    return false if y < @height and @getCellColor originX, y
    return true
  tick: ->
    # Are there marked cells?
      # Yes
        # For each marked cell
          # Clear cell
          # Decrement virus count if cell contained virus
      # No
        # Are there orphans?
          # Yes
            # For each orphan
              # Drop orphan
              # If orphan drop created lines
                # Mark line cells
          # No
            # Is there a falling capsule?
              # No - Generate new capsule
              # Yes - Drop capsule
            # If input, rotate/move capsule
            # Is capsule stacked or landed?
              # Write capsule to grid
              # Clear capsule
              # If capsule write created lines
                # Mark line cells
    @ticks += 1
    return
