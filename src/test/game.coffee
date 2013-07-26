Cell = require './cell'
Line = require './line'
Grid = require './grid'

defaultWidth = 10
defaultHeight = 16
defaultSpeed = 8
defaultLevel = 10
defaultNumColors = 3
maxNumColors = 15
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
    @numColors = options.numColors ? defaultNumColors
    @numColors = maxNumColors if @numColors > maxNumColors
    @minLineLength = options.minLineLength ? defaultMinLineLength
    @maxYCeiling = options.maxYCeiling ? defaultMaxYCeiling
    @levelVirusMultiplier =
      options.levelVirusMultiplier ? defaultLevelVirusMultiplier
    level = options.level ? defaultLevel
    @resetToLevel level
  resetToLevel: (level) ->
    # Reset and redimension game grid
    @grid = new Grid @width, @height
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
      isCellInLines = true
      while isCellInLines
        randomVirus = Cell.setVirus Cell.randomColor()
        @grid.set x, y, randomVirus
        isCellInLines = @grid.findLines x, y
      @virusesLeft += 1
    return
  tick: ->
    if clearResult = @grid.clearMarked()
      # Unpack the 32-bit result into 2 16-bit integers
      virusesCleared = clearResult >>> 16
      cellsCleared = clearResult & 0xFFFF
      console.log "Cleared %d cells, %d viruses", cellsCleared, virusesCleared
    # else
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
          # If input, try to rotate/move capsule
          # Is capsule stacked or landed?
            # Write capsule to grid
            # Clear capsule
            # If capsule write created lines
              # Mark line cells
    @ticks += 1
    return
