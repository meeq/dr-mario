exports.colorNames = colorNames = [
  'red'
  'yellow'
  'blue'
]

exports.numColors = numColors = colorNames.length

exports.randomCell = ->
  Math.floor Math.random() * (numColors + 1)

exports.randomColor = ->
  1 + (Math.floor Math.random() * numColors)
