desiredFps = 60

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
detaultLevel = 10
defaultMinLineLength = 3

cellColors = [
  'red'
  'yellow'
  'blue'
]
numCellColors = cellColors.length
randomCellColor = (allowEmpty) ->
  cellColor = Math.floor Math.random() * (numCellColors + allowEmpty)
  if allowEmpty
    if cellColor < numCellColors then cellColor else 0
  else
    cellColor + 1

getCell = (x, y) -> @[x * (y + 1)] | 0

class Game
  constructor: (options) ->
    @ticks = 0
    if options?
      @width = options.width ? defaultWidth
      @height = options.height ? defaultHeight
      @speed = options.speed ? defaultSpeed
      @minLineLength = options.minLineLength ? defaultMinLineLength
      level = options.level ? defaultLevel
  resetToLevel: (level) ->
    yCeiling = @height - level
    numCells = @width * @height
    # Create game state
    @virusesLeft = 0
    @grid = []
    @virusGrid = []
    @neighborsGrid = []
    @fallingBlocks = []
    @fallingCleanup = []
    # Mixin state helpers and dimension state arrays
    @grid.getCell = @virusGrid.getCell = @neighborsGrid.getCell = getCell
    @grid.length = @virusGrid.length = @neighborsGrid.length = numCells
    # Initialize the game state from the top-left corner
    for x in [0..@width]
      for y in [0..@height]
        cellIndex = x * (y + 1)
        @neighborsGrid[cellIndex] = 0
        if y >= yCeiling and not (@testCellForLine x, y)
          # Random virus or empty cell
          @grid[cellIndex] = cellColor = (randomCellColor true)
          if cellColor isnt 0
            @virusGrid[cellIndex] = 1
            @virusesLeft += 1
    return
  testCellForLine: (originX, originY) ->
    # Vertical test
    x = originX
    y = originY - 1
    if y >= 0 and (@grid.getCell x, y) isnt 0
      y -= 1 while y > 0 and (@grid.getCell x, y) is (@grid.getCell x, y - 1)
      return true if originY - y >= @minLineLength
    # Horizontal test
    x = originX - 1
    y = originY
    if x >= 0 and (@grid.getCell x, y) isnt 0
      x -= 1 while x > 0 and (@grid.getCell x, y) is (@grid.getCell x - 1, y)
      return true if originX - x >= @minLineLength
    return false
  tick: ->
    # Drop the falling blocks 1 cell
    @fallingCleanup.length = 0
    for block, i in @fallingBlocks
      if (@ticks % block.speed) is 0
        @fallingCleanup.push i if (dropBlock block)
    # Clean up any blocks that have landed
    for cleanupIndex in @fallingCleanup by -1
      @fallingBlocks.splice cleanupIndex, 1



module.exports = class TestApp
  start: ->
    @game = new Game
    return
  clockRate: 1000 / desiredFps
  clockRef: null
  unpause: ->
    @clockRef = setInterval @tick, 1000
    return
  pause: ->
    clearInterval @clockRef
    @clockRef = null
    return
  tick: =>
    @game.tick()
    return
