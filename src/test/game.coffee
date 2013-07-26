Cell = require './cell'
Line = require './line'
Grid = require './grid'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultNumColors = 3
minNumColors = 1
maxNumColors = 15
defaultLineLength = 4
defaultMaxYCeiling = 3
defaultLevelVirusMultiplier = 4

randomInRange = (start, end) ->
  start + (Math.random() * (end - start)) | 0

module.exports = class Game
  supportsTypedArrays: window.ArrayBuffer? and window.Uint8ClampedArray?
  constructor: (options = {}) ->
    # Timing
    @ticks = 0
    @speed = options.speed ? defaultSpeed
    # Dimensions
    @width = options.width ? defaultWidth
    @height = options.height ? defaultHeight
    # Clamped number of cell colors
    @numColors = options.numColors ? defaultNumColors
    @numColors = minNumColors if @numColors < minNumColors
    @numColors = maxNumColors if @numColors > maxNumColors
    # Tweaks
    @lineLength = options.lineLength ? defaultLineLength
    @maxYCeiling = options.maxYCeiling ? defaultMaxYCeiling
    @levelVirusMultiplier =
      options.levelVirusMultiplier ? defaultLevelVirusMultiplier
    # Create the grid
    @resetToLevel options.level ? defaultLevel
  resetToLevel: (level) ->
    @grid = new Grid @
    # Create an index of available cells for viruses
    yCeiling = @height - level
    yCeiling = @maxYCeiling if yCeiling < @maxYCeiling
    topLeftOpenIndex = (yCeiling * @width)
    bottomRightOpenIndex = @width + ((@height - 1) * @width)
    openCellIndexes = [topLeftOpenIndex...bottomRightOpenIndex]
    # Randomly generate viruses on grid
    @virusesLeft = 0
    levelViruses = (@levelVirusMultiplier * level) + @levelVirusMultiplier
    while @virusesLeft < levelViruses and openCellIndexes.length
      # Get a random cell and remove it from the available cell list
      randomOpenIndex = randomInRange 0, openCellIndexes.length
      cellIndex = openCellIndexes[randomOpenIndex]
      openCellIndexes.splice randomOpenIndex, 1
      # Convert the random cell index back into grid coordinates
      x = (cellIndex % @width)
      y = (cellIndex / @width) | 0
      # Generate a randomly colored virus in the cell that won't create a line
      # Give up if it is impossible to fill the cell without creating a line
      didCellCreateLines = true
      attemptsLeft = @numColors * 2
      while didCellCreateLines and attemptsLeft
        randomVirus = Cell.setVirus Cell.randomColor @numColors
        @grid.set x, y, randomVirus
        didCellCreateLines = @grid.findLines x, y
        attemptsLeft -= 1
      if didCellCreateLines
        # Skip the cell
        @grid.clear x, y
      else
        @virusesLeft += 1
    return
  tick: ->
    @ticks += 1
    return if @ticks % @speed
    if clearResult = @grid.clearMarked()
      # Unpack the 32-bit result into 2 16-bit integers
      virusesCleared = clearResult >>> 16
      cellsCleared = clearResult & 0xFFFF
      console.log "Cleared %d cells, %d viruses", cellsCleared, virusesCleared
      # TODO Check virusesLeft, win state
    else if dropResult = @grid.dropFalling()
      console.log "Dropped %d cells", dropResult
    # else
      # Is there a falling capsule?
        # No
          # Is there space to generate a new capsule?
            # Yes - Generate new capsule
            # No - Game over
        # Yes - Drop capsule
      # If input, try to rotate/move capsule
      # Is capsule stacked or landed?
        # Write capsule to grid
        # Clear capsule
        # If capsule write created lines
          # Mark line cells
    return
