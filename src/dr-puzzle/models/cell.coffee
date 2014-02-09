# Cells are defined as an clamped unsigned 8-bit integer
exports.EMPTY = EMPTY = 0 | 0

colorNames = [
  'red'
  'yellow'
  'blue'
  'green'
  'white'
  'black'
  'pink'
]

exports.randomColor = (numColors = colorNames.length) ->
  numColors = numColors | 0
  (1 + (Math.random() * numColors)) | 0

exports.isEmpty = (cell) ->
  cell = cell | 0
  cell is EMPTY

colorMask = 0b00000111 # 3-bit integer at offset 0

exports.getColor = getColor = (cell) ->
  cell = cell | 0
  (cell & colorMask) | 0

exports.getColorName = (cell) ->
  cell = cell | 0
  colorNames[(getColor cell) - 1]

virusMask = 0b10000000 # 1-bit flag at offset 8
virusShift = (Math.log(virusMask) / Math.LN2) | 0

exports.isVirus = (cell) ->
  cell = cell | 0
  ((cell & virusMask) >>> virusShift) | 0

exports.setVirus = (cell) ->
  cell = cell | 0
  (cell | virusMask) | 0

markMask = 0b01000000 # 1-bit flag at offset 7
markShift = (Math.log(markMask) / Math.LN2) | 0

exports.isMarked = (cell) ->
  cell = cell | 0
  ((cell & markMask) >>> markShift) | 0

exports.setMark = (cell) ->
  cell = cell | 0
  (cell | markMask) | 0

directionMask = 0b00111000 # 3-bit integer at offset 4
directionShift = ((Math.log(directionMask) / Math.LN2) - 2) | 0

exports.getDirection = (cell) ->
  cell = cell | 0
  ((cell & directionMask) >>> directionShift) | 0

exports.setDirection = (cell, direction) ->
  cell = cell | 0
  direction = direction | 0
  cell = (cell & ~directionMask) | 0
  cell = (cell | (direction << directionShift)) | 0 if direction
  cell | 0
