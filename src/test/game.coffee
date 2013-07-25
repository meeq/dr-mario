Cell = require './cell'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultMinLineLength = 4
defaultMaxYCeiling = 3
defaultLevelVirusMultiplier = 4

Line =
  NONE: 0
  X:    1
  Y:    2
  XY:   3
  hasX: (line) -> line & Line.X
  hasY: (line) -> line & Line.Y

randomInRange = (start, end) ->
  start + (Math.floor Math.random() * (end - start))

module.exports = class Game
  constructor: (options = {}) ->
    @ticks = 0
    @grid = []
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
    @grid.length = 0
    @grid.length = @width * @height
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
        cellLineDir = @getCellLineDirection x, y
      @virusesLeft += 1
    return
  getCell: (x, y) ->
    @grid[x + (y * @width)] | 0
  getCellColor: (x, y) ->
    Cell.colorIndex (@getCell x, y)
  setCell: (x, y, value) ->
    @grid[x + (y * @width)] = value | 0
  markCell: (x, y) ->
    cell = @getCell x, y
    @setCell x, y, (Cell.setMark cell)
  getCellLineDirection: (originX, originY) ->
    cellColor = @getCellColor originX, originY
    return false if not cellColor
    # Horizontal Left
    testX = originX - 1
    left = 0
    while testX >= 0 and (@getCellColor testX, originY) is cellColor
      left += 1
      testX -= 1
    # Horizontal Right
    testX = originX + 1
    right = 0
    while testX < @width and (@getCellColor testX, originY) is cellColor
      right += 1
      testX += 1
    # Vertical Up
    testY = originY - 1
    up = 0
    while testY >= 0 and (@getCellColor originX, testY) is cellColor
      up += 1
      testY -= 1
    # Vertical Down
    testY = originY + 1
    down = 0
    while testY < @height and (@getCellColor originX, testY) is cellColor
      down += 1
      testY += 1
    isVerticalLine = 1 + left + right >= @minLineLength
    isHorizontalLine = 1 + up + down >= @minLineLength
    if isVerticalLine and isHorizontalLine then Line.XY
    else if isVerticalLine then Line.Y
    else if isHorizontalLine then Line.X
    else Line.NONE
  isCellOrphaned: (originX, originY) ->
    cell = @getCell originX, originY
    return false if (Cell.isVirus cell) or not (Cell.colorIndex cell)
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
