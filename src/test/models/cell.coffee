# Cells are defined as an clamped unsigned 8-bit integer
exports.EMPTY = EMPTY = 0

colorNames = [
  'red'
  'yellow'
  'blue'
  'green'
  'white'
  'black'
  'pink'
]

exports.randomColor = (numColors) ->
  numColors ?= colorNames.length
  1 + (Math.random() * numColors) | 0

exports.isEmpty = (cell) ->
  cell is EMPTY

colorMask = 0b00000111 # 3-bit integer at offset 0

exports.getColor = getColor = (cell) ->
  cell & colorMask

exports.getColorName = (cell) ->
  colorNames[(getColor cell) - 1]

virusMask = 0b10000000 # 1-bit flag at offset 8
virusShift = Math.log(virusMask) / Math.LN2

exports.isVirus = (cell) ->
  (cell & virusMask) >>> virusShift

exports.setVirus = (cell) ->
  cell | virusMask

markMask = 0b01000000 # 1-bit flag at offset 7
markShift = Math.log(markMask) / Math.LN2

exports.isMarked = (cell) ->
  (cell & markMask) >>> markShift

exports.setMark = (cell) ->
  cell | markMask

directionMask = 0b00111000 # 3-bit integer at offset 4
directionShift = ((Math.log directionMask) / Math.LN2) - 2

exports.getDirection = (cell) ->
  (cell & directionMask) >>> directionShift

exports.setDirection = (cell, direction) ->
  cell = cell & ~directionMask
  return cell if not direction
  cell | (direction << directionShift)
