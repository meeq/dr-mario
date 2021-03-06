Cell = require './cell'
Direction = require './direction'
Matrix = require './matrix'
Capsule = require './capsule'
PlayerInput = require './player-input'
Speed = require './speed'

# TODO Refactor this into defaults
defaultWidth = 10
defaultHeight = 16
defaultSpeed = Speed.MED
defaultLevel = 10
defaultNumColors = 3
minNumColors = 1
maxNumColors = 7
maxSpeedCount = 49
defaultCapsuleSize = 2
defaultLineLength = 4
defaultMinYCeiling = 3
defaultMaxYCeiling = 9
defaultSpeedUpRate = 10
defaultFallingTickRate = 8
defaultLevelVirusMultiplier = 4

minCombo = 1
maxCombo = 6
scoreMultiplier = 100
calculateScore = (speed, numViruses) ->
  numViruses = numViruses | 0
  baseCombo = Speed.baseScoreCombo speed
  numCombos = clamp numViruses, minCombo, maxCombo
  score = 0
  for comboIndex in [minCombo..numCombos]
    score += (scoreMultiplier * (Math.pow baseCombo, comboIndex)) | 0
  score | 0

randomInRange = (start, end) ->
  start = start | 0
  end = end | 0
  (start + (Math.random() * (end - start))) | 0

clamp = (val, min, max) ->
  val = val | 0
  min = min | 0
  max = max | 0
  (Math.min (Math.max val, min), max) | 0

module.exports = class PlayerState
  constructor: (options = {}) ->
    @game = options.game
    # Timing
    @speed = (Speed.fromOption options.speed) ? defaultSpeed
    # Dimensions
    @width = options.width ? defaultWidth
    @height = options.height ? defaultHeight
    # Clamped number of cell colors
    @numColors = options.numColors ? defaultNumColors
    @numColors = clamp @numColors, minNumColors, maxNumColors
    # Tweaks
    @lineLength = options.lineLength ? defaultLineLength
    @capsuleSize = options.capsuleSize ? defaultCapsuleSize
    @minYCeiling = options.minYCeiling ? defaultMinYCeiling
    @maxYCeiling = options.maxYCeiling ? defaultMaxYCeiling
    @fallingTickRate = options.fallingTickRate ? defaultFallingTickRate
    @speedUpRate = options.speedUpRate ? defaultSpeedUpRate
    @levelVirusMultiplier =
      options.levelVirusMultiplier ? defaultLevelVirusMultiplier
    # Setup grid
    @reset options.level ? defaultLevel
  reset: (level) ->
    @isGameOver = false
    @level = level ? @level ? defaultLevel
    @score = 0
    @speedCount = 0
    @capsuleCount = 0
    @tickCount = 0
    @tickRate = Speed.calculateTickRate @speed, @speedCount
    @grid = new Matrix @
    @capsule = new Capsule @
    # Create an index of available cells for viruses
    yCeiling = clamp @height - @level, @minYCeiling, @maxYCeiling
    topLeftOpenIndex = (yCeiling * @width)
    bottomRightOpenIndex = @width + ((@height - 1) * @width)
    openCellIndexes = [topLeftOpenIndex...bottomRightOpenIndex]
    # Randomly generate viruses on grid
    @virusesLeft = 0
    @virusesLeftByColor = [0]
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
        randomColor = Cell.randomColor @numColors
        randomVirus = Cell.setVirus randomColor
        @grid.set x, y, randomVirus
        lineDirection = @grid.checkLineDirections x, y
        attemptsLeft -= 1
      # Give up if it is impossible to fill the cell without creating a line
      if lineDirection
        @grid.clear x, y
      else
        @virusesLeft += 1
        if @virusesLeftByColor[randomColor]?
          @virusesLeftByColor[randomColor] += 1
        else
          @virusesLeftByColor[randomColor] = 1
    return
  tick: ->
    @tickCount += 1
    # Skip the tick if the game is over
    if @isGameOver or @tickCount % @tickRate
      return false
    # End the game if there are no objectives left
    else if 0 is @virusesLeft
      @isGameOver = true
      @game.playerDidEndGame @, true
    # Handle falling capsule
    else if @capsule.isFalling()
      # If the capsule can't fit in the grid, it's over.
      if @capsule.isOutOfBounds()
        @isGameOver = true
        @game.playerDidEndGame @, false
        return true
      @capsule.drop()
      # Allow the capsule to "slide" for a tick
      isPlaced = @tickCount isnt @capsule.landedTick or @tickRate is 0
      if @capsule.isLanded() and isPlaced
        @capsule.writeToGrid()
        @game.playerDidWriteCellsToGrid @, @capsule.size
        # Switch to "falling speed"
        @tickRate = @fallingTickRate if @fallingTickRate?
        if linesMarked = @grid.markLines()
          @recomputeVirusesLeft linesMarked
    # Clear marked cells
    else if clearResult = @grid.clearMarked()
      # Unpack the 32-bit result into 2 16-bit integers
      virusesCleared = clearResult >>> 16
      cellsCleared = clearResult & 0xFFFF
      @score += calculateScore @speed, virusesCleared if virusesCleared
      @game.playerDidClearMarked @, cellsCleared, virusesCleared
    # Drop any loose, falling cells
    else if cellsDropped = @grid.dropFalling()
      @game.playerDidWriteCellsToGrid @, cellsDropped
    # Mark any falling cells that have landed
    else if linesMarked = @grid.markLines()
      @recomputeVirusesLeft linesMarked
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
      @tickRate = Speed.calculateTickRate @speed, @speedCount
    return true
  recomputeVirusesLeft: (linesMarked) ->
    linesMarked = linesMarked | 0
    virusesMarked = 0
    didClearColor = false
    for colorIndex in [1..@numColors]
      markedColoredVirus = Cell.setVirus Cell.setMark colorIndex
      if numMarkedColoredViruses = @grid.count markedColoredVirus
        virusesMarked += numMarkedColoredViruses
        if 0 is @virusesLeftByColor[colorIndex] -= numMarkedColoredViruses
          didClearColor = true
    @virusesLeft -= virusesMarked if virusesMarked
    @game.playerDidMarkLines @, linesMarked, virusesMarked, didClearColor
    return
  applyInput: (input) ->
    return if not @capsule.isFalling() or @capsule.isOutOfBounds()
    if PlayerInput.get input, PlayerInput.MOVE_LEFT
      @capsule.move Direction.LEFT
    if PlayerInput.get input, PlayerInput.MOVE_RIGHT
      @capsule.move Direction.RIGHT
    if PlayerInput.get input, PlayerInput.FLIP_LEFT
      @capsule.rotate Direction.LEFT
    if PlayerInput.get input, PlayerInput.FLIP_RIGHT
      @capsule.rotate Direction.RIGHT
    if PlayerInput.get input, PlayerInput.FAST_DROP
      @tickRate = 0
    else if @tickRate is 0
      @tickRate = Speed.calculateTickRate @speed, @speedCount
    if PlayerInput.get input, PlayerInput.INSTANT_DROP
      @capsule.drop() while not @capsule.isLanded()
      @tickRate = 0
    if PlayerInput.get input, PlayerInput.SWAP_HOLD
      @capsule.swapHold()
    return
