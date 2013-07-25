Cell = require './cell'

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
    # Create game state
    @grid = []
    # Mixin dimension state arrays
    @grid.length = @width * @height
    # Randomly generate the game grid
    yCeiling = @height - level
    yCeiling = @maxYCeiling if yCeiling < @maxYCeiling
    levelViruses = (@levelVirusMultiplier * level) + @levelVirusMultiplier
    @virusesLeft = 0
    topLeftOpenIndex = (yCeiling * @width)
    bottomRightOpenIndex = @width+((@height-1) * @width)
    openCellIndexes = [topLeftOpenIndex...bottomRightOpenIndex]
    while @virusesLeft < levelViruses and openCellIndexes.length
      randomOpenIndex = randomInRange 0, openCellIndexes.length
      cellIndex = openCellIndexes[randomOpenIndex]
      openCellIndexes.splice randomOpenIndex, 1
      x = (cellIndex % @width)
      y = (cellIndex / @width) | 0
      isCellInLine = true
      while isCellInLine
        cell = Cell.setVirus Cell.randomColorIndex()
        @setCell x, y, cell
        isCellInLine = @isCellInLine x, y
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
  isCellInLine: (originX, originY, markCells = false) ->
    cellColor = @getCellColor originX, originY
    return false if not cellColor
    # Horizontal Left
    x = originX - 1
    left = 0
    while x >= 0 and (@getCellColor x, originY) is cellColor
      (@markCell x, originY) if markCells
      left += 1
      x -= 1
    # Horizontal Right
    x = originX + 1
    right = 0
    while x < @width and (@getCellColor x, originY) is cellColor
      (@markCell x, originY) if markCells
      right += 1
      x += 1
    return true if 1 + left + right >= @minLineLength
    # Vertical Up
    y = originY - 1
    up = 0
    while y >= 0 and (@getCellColor originX, y) is cellColor
      (@markCell originX, y) if markCells
      up += 1
      y -= 1
    # Vertical Down
    y = originY + 1
    down = 0
    while y < @height and (@getCellColor originX, y) is cellColor
      (@markCell originX, y) if markCells
      down += 1
      y += 1
    return true if 1 + up + down >= @minLineLength
    return false
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
