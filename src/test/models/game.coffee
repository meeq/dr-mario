Cell = require './cell'
Direction = require './direction'
Grid = require './grid'
Capsule = require './capsule'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultNumColors = 3
minNumColors = 1
maxNumColors = 7
defaultCapsuleSize = 2
defaultLineLength = 4
defaultMaxYCeiling = 3
defaultLevelVirusMultiplier = 4

randomInRange = (start, end) ->
  start + (Math.random() * (end - start)) | 0

module.exports = class Game
  constructor: (options = {}) ->
    # Timing
    @ticks = 0
    @level = options.level ? defaultLevel
    @speed = options.speed ? defaultSpeed
    # Dimensions
    @width = options.width ? defaultWidth
    @height = options.height ? defaultHeight
    # Clamped number of cell colors
    @numColors = options.numColors ? defaultNumColors
    @numColors = (Math.min (Math.max @numColors, minNumColors), maxNumColors)
    # Tweaks
    @lineLength = options.lineLength ? defaultLineLength
    @capsuleSize = options.capsuleSize ? defaultCapsuleSize
    @maxYCeiling = options.maxYCeiling ? defaultMaxYCeiling
    @levelVirusMultiplier =
      options.levelVirusMultiplier ? defaultLevelVirusMultiplier
  reset: (level) ->
    @level = level ? @level ? defaultLevel
    @grid = new Grid @
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
      x = (cellIndex % @width)
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
    return false if @isGameOver or @ticks % @speed
    if @capsule.isFalling()
      @capsule.applyInput input
      @capsule.drop()
      if @capsule.isLanded()
        if @capsule.isOutOfBounds()
          console.log "Game over!"
          @isGameOver = true
        else if @ticks isnt @capsule.landedTick
          console.log "Writing capsule to grid"
          @capsule.writeToGrid()
          if markResult = @grid.markLines()
            console.log 'Marked %d lines', markResult
    else if clearResult = @grid.clearMarked()
      # Unpack the 32-bit result into 2 16-bit integers
      virusesCleared = clearResult >>> 16
      cellsCleared = clearResult & 0xFFFF
      console.log "Cleared %d cells, %d viruses", cellsCleared, virusesCleared
      @virusesLeft -= virusesCleared
      if @virusesLeft is 0
        console.log "You win!"
        @isGameOver = true
    else if dropResult = @grid.dropFalling()
      console.log "Dropped %d cells", dropResult
      if markResult = @grid.markLines()
        console.log 'Marked %d lines', markResult
    else
      console.log "Generating new capsule"
      @capsule.generate()
    return true
