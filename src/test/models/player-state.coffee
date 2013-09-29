Cell = require './cell'
Direction = require './direction'
Matrix = require './matrix'
Capsule = require './capsule'

# TODO Refactor this into defaults
defaultWidth = 10
defaultHeight = 16
defaultSpeed = 'med'
defaultLevel = 10
defaultNumColors = 3
minNumColors = 1
maxNumColors = 7
maxSpeedCount = 49
defaultCapsuleSize = 2
defaultLineLength = 4
defaultMaxYCeiling = 3
defaultSpeedUpRate = 10
defaultFallingTickRate = 15
defaultLevelVirusMultiplier = 4

speedToBaseIndex = (speed) ->
  switch speed
    when 'lo'  then 15
    when 'med' then 25
    when 'hi'  then 31

speedIndexToTickRate = (index) ->
  if      index <= 25 then (35 - index) * 2 - 1
  else if index <= 34 then 44 - index
  else if index <= 36 then 9
  else if index <= 38 then 8
  else if index <= 40 then 7
  else if index <= 42 then 6
  else if index <= 54 then 5
  else if index <= 59 then 4
  else if index <= 64 then 3
  else if index <= 69 then 2
  else                     1

randomInRange = (start, end) ->
  start + (Math.random() * (end - start)) | 0

clamp = (val, min, max) ->
  (Math.min (Math.max val, min), max)

module.exports = class PlayerState
  constructor: (options = {}) ->
    @game = options.game
    # Timing
    @speed = options.speed ? defaultSpeed
    @baseSpeed = speedToBaseIndex @speed
    # Dimensions
    @width = options.width ? defaultWidth
    @height = options.height ? defaultHeight
    # Clamped number of cell colors
    @numColors = options.numColors ? defaultNumColors
    @numColors = clamp @numColors, minNumColors, maxNumColors
    # Tweaks
    @lineLength = options.lineLength ? defaultLineLength
    @capsuleSize = options.capsuleSize ? defaultCapsuleSize
    @maxYCeiling = options.maxYCeiling ? defaultMaxYCeiling
    @fallingTickRate = options.fallingTickRate ? defaultFallingTickRate
    @speedUpRate = options.speedUpRate ? defaultSpeedUpRate
    @levelVirusMultiplier =
      options.levelVirusMultiplier ? defaultLevelVirusMultiplier
    # Setup grid
    @reset options.level ? defaultLevel
  reset: (level) ->
    @speedCount = 0
    @capsuleCount = 0
    @tickRate = speedIndexToTickRate (@baseSpeed + @speedCount)
    @ticks = 0
    @level = level ? @level ? defaultLevel
    @grid = new Matrix @
    @capsule = new Capsule @
    @isGameOver = false
    # Create an index of available cells for viruses
    yCeiling = @height - @level
    yCeiling = @maxYCeiling if yCeiling < @maxYCeiling
    topLeftOpenIndex = (yCeiling * @width)
    bottomRightOpenIndex = @width + ((@height - 1) * @width)
    openCellIndexes = [topLeftOpenIndex...bottomRightOpenIndex]
    # Randomly generate viruses on grid
    @virusesLeft = 0
    levelViruses = (@levelVirusMultiplier * @level) + @levelVirusMultiplier
    while @virusesLeft < levelViruses and openCellIndexes.length
      # Get a random cell and remove it from the available cell list
      randomOpenIndex = randomInRange 0, openCellIndexes.length
      cellIndex = openCellIndexes[randomOpenIndex]
      openCellIndexes.splice randomOpenIndex, 1
      # Convert the random cell index back into grid coordinates
      x = (cellIndex % @width) | 0
      y = (cellIndex / @width) | 0
      # Generate a randomly colored virus in the cell that won't create a line
      lineDirection = Direction.CROSS
      attemptsLeft = @numColors * 2
      while lineDirection and attemptsLeft
        randomVirus = Cell.setVirus Cell.randomColor @numColors
        @grid.set x, y, randomVirus
        lineDirection = @grid.checkLineDirections x, y
        attemptsLeft -= 1
      # Give up if it is impossible to fill the cell without creating a line
      if lineDirection
        @grid.clear x, y
      else
        @virusesLeft += 1
    return
  tick: (input) ->
    @ticks += 1
    return false if @isGameOver or @ticks % @tickRate
    # Drop falling capsule
    if @capsule.isFalling()
      @capsule.applyInput input
      @capsule.drop()
      @game.playerDidDropCapsule @
      if @capsule.isLanded()
        # If the capsule can't fit in the grid, it's over.
        if @capsule.isOutOfBounds()
          @isGameOver = true
          @game.playerDidEndGame @, false
        # Allow the capsule to "slide" for a tick
        else if @ticks isnt @capsule.landedTick
          @capsule.writeToGrid()
          # Switch to "falling speed"
          @tickRate = @fallingTickRate if @fallingTickRate?
          if markResult = @grid.markLines()
            @game.playerDidMarkLines @, markResult
    # Clear marked cells
    else if clearResult = @grid.clearMarked()
      # Unpack the 32-bit result into 2 16-bit integers
      virusesCleared = clearResult >>> 16
      cellsCleared = clearResult & 0xFFFF
      @game.playerDidClearMarked @, cellsCleared, virusesCleared
      # Check if the game is over because we are out of viruses.
      if 0 is @virusesLeft -= virusesCleared
        @isGameOver = true
        @game.playerDidEndGame @, true
    # Drop any loose, falling cells
    else if dropResult = @grid.dropFalling()
      @game.playerDidDropCapsule @, dropResult
    # Mark any falling cells that have landed
    else if markResult = @grid.markLines()
      @game.playerDidMarkLines @, markResult
    # Generate a new capsule
    else
      @capsule.generate()
      @game.playerDidSpawnCapsule @
      @capsuleCount += 1
      # Speed up
      if 0 is @capsuleCount % @speedUpRate and @speedCount < maxSpeedCount
        @speedCount += 1
        @game.playerDidSpeedUp @
      # Switch back to "player speed"
      @tickRate = speedIndexToTickRate (@baseSpeed + @speedCount)
    return true
