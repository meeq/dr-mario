colors = require './colors'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultMinLineLength = 4
defaultMaxYCeiling = 3
defaultLevelVirusMultiplier = 4

randomInRange = (start, end) ->
  start + (Math.floor Math.random() * (end - start))

getCell = (x, y) -> @[x + (y * @width)] | 0
setCell = (x, y, value) -> @[x + (y * @width)] = value | 0

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
    @virusGrid = []
    # Mixin state helpers and dimension state arrays
    @grid.getCell = @virusGrid.getCell = getCell
    @grid.setCell = @virusGrid.setCell = setCell
    @grid.width = @virusGrid.width = @width
    @grid.length = @virusGrid.length = @width * @height
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
      doesCellMakeLine = true
      while doesCellMakeLine
        color = colors.randomColor()
        @grid.setCell x, y, color
        doesCellMakeLine = @testCellForLine x, y
      @virusGrid.setCell x, y, 1
      @virusesLeft += 1
    return
  testCellForLine: (originX, originY) ->
    cellColor = @grid.getCell originX, originY
    return false if not cellColor
    # Vertical Up
    x = originX
    y = originY - 1
    up = 0
    while y >= 0 and (@grid.getCell x, y) is cellColor
      up += 1
      y -= 1
    # Vertical Down
    y = originY + 1
    down = 0
    while y < @height and (@grid.getCell x, y) is cellColor
      down += 1
      y += 1
    return true if 1 + up + down >= @minLineLength
    # Horizontal Left
    x = originX - 1
    y = originY
    left = 0
    while x >= 0 and (@grid.getCell x, y) is cellColor
      left += 1
      x -= 1
    # Horizontal Right
    x = originX + 1
    right = 0
    while x < @width and (@grid.getCell x, y) is cellColor
      right += 1
      x += 1
    return true if 1 + left + right >= @minLineLength
    return false
  tick: ->
    # Orphans?
      # Yes
        # Drop orphans
        # If lines in orphans drop
          # Clear lines
      # No
        # Capsule?
          # No - Generate capsule
          # Yes - Drop capsule
        # If input, rotate/move capsule
        # If capsule stacked or landed
          # Write capsule to grid
          # Clear capsule
          # If lines in capsule drop
            # Clear lines
