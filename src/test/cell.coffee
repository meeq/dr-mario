# Cells are defined as an clamped unsigned 8-bit integer

colorNames = [
  'red'
  'yellow'
  'blue'
  # TODO 12 more colors! :D
]

exports.randomColor = (numColors) ->
  numColors ?= colorNames.length
  1 + (Math.floor Math.random() * numColors)

exports.isEmpty = (cell) ->
  cell is 0

colorMask = 0b00001111 # 4-bit integer at offset 0

exports.getColor = getColor = (cell) ->
  cell & colorMask

exports.getColorName = (cell) ->
  colorNames[(getColor cell) - 1]

virusMask = 0b10000000 # 1-bit flag at offset 7
virusShift = Math.log(virusMask) / Math.LN2

exports.isVirus = (cell) ->
  (cell & virusMask) >>> virusShift

exports.setVirus = (cell) ->
  cell | virusMask

markMask = 0b01000000 # 1-bit flag at offset 6
markShift = Math.log(markMask) / Math.LN2

exports.isMarked = (cell) ->
  (cell & markMask) >>> markShift

exports.setMark = (cell) ->
  cell | markMask

mateMask = 0b00110000 # 2-bit integer at offset 4
mateShift = ((Math.log mateMask) / Math.LN2) - 1

exports.getMate = (cell) ->
  (cell & mateMask) >>> mateShift

exports.setMate = (cell, mate) ->
  cell = cell & ~mateMask
  return cell if not mate
  cell | (mate << mateShift)
