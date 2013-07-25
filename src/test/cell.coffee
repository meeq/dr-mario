colorNames = [
  'red'
  'yellow'
  'blue'
]

exports.numColors = numColors = colorNames.length

exports.randomColorIndex = ->
  1 + (Math.floor Math.random() * numColors)

colorMask = 0x03

exports.getColorIndex = getColorIndex = (cell) ->
  cell & colorMask

exports.getColorName = (cell) ->
  colorNames[(getColorIndex cell) - 1]

virusMask = 0x80
virusShift = Math.log(virusMask) / Math.LN2 # 1-bit flag

exports.isVirus = (cell) ->
  (cell & virusMask) >>> virusShift

exports.setVirus = (cell) ->
  cell | virusMask

markMask = 0x40
markShift = Math.log(markMask) / Math.LN2 # 1-bit flag

exports.isMarked = (cell) ->
  (cell & markMask) >>> markShift

exports.setMark = (cell) ->
  cell | markMask

neighborMask = 0x30
neighborShift = ((Math.log neighborMask) / Math.LN2) - 1 # 2-bit integer

exports.getNeighbor = (cell) ->
  (cell & neighborMask) >>> neighborShift

exports.setNeighbor = (cell, neighbor) ->
  cell = cell & ~neighborMask
  cell | (neighbor << neighborShift)
