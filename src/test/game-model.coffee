colors = require './colors'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultMinLineLength = 4

randomInRange = (start, end) ->
  start + (Math.floor Math.random() * (end - start))

getCell = (x, y) -> @[x + (y * @height)] | 0
setCell = (x, y, value) -> @[x + (y * @height)] = value | 0

module.exports = class Game
  constructor: (options = {}) ->
    @ticks = 0
    @width = options.width ? defaultWidth
    @height = options.height ? defaultHeight
    @speed = options.speed ? defaultSpeed
    @minLineLength = options.minLineLength ? defaultMinLineLength
    level = options.level ? defaultLevel
    @resetToLevel level
  resetToLevel: (level) ->
    yCeiling = @height - level
    yCeiling = 2 if yCeiling < 2
    numCells = @width * @height
    # Create game state
    @virusesLeft = 0
    @grid = []
    @virusGrid = []
    # Mixin state helpers and dimension state arrays
    @grid.getCell = @virusGrid.getCell = getCell
    @grid.setCell = @virusGrid.setCell = setCell
    @grid.height = @virusGrid.height = @height
    @grid.length = @virusGrid.length = numCells
    # Randomly generate the game grid
    levelViruses = (4 * level) + 4
    @virusesLeft = 0
    while @virusesLeft < levelViruses
      x = randomInRange 0, @width - 1
      y = randomInRange yCeiling, @height - 1
      if not (@grid.getCell x, y) and not (@testCellForLine x, y)
        @grid.setCell x, y, colors.randomColor()
        @virusGrid.setCell x, y, 1
        @virusesLeft += 1
    return
  # This heuristic sucks.
  testCellForLine: (originX, originY) ->
    # Vertical test
    x = originX
    y = originY - 1
    if y >= 0 and (@grid.getCell x, y) isnt 0
      while y > 0 and (@grid.getCell x, y) is (@grid.getCell x, y - 1)
        y -= 1
      if originY - y >= @minLineLength - 1
        return true
    # Horizontal test
    x = originX - 1
    y = originY
    if x >= 0 and (@grid.getCell x, y) isnt 0
      while x > 0 and (@grid.getCell x, y) is (@grid.getCell x - 1, y)
        x -= 1
      if originX - x >= @minLineLength - 1
        return true
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
