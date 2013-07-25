colorNames = [
  'red'
  'yellow'
  'blue'
]

exports.numColors = numColors = colorNames.length

exports.randomColorIndex = ->
  1 + (Math.floor Math.random() * numColors)

colorMask = 0x00000003

exports.colorIndex = colorIndex = (cell) ->
  cell & colorMask

exports.colorName = (cell) ->
  colorNames[(colorIndex cell) - 1]

virusMask = 0x80000000

exports.isVirus = (cell) ->
  cell & virusMask

exports.setVirus = (cell) ->
  cell | virusMask

markMask = 0x40000000

exports.isMarked = (cell) ->
  cell & markMask

exports.setMark = (cell) ->
  cell | markMask
