module.exports = Line =
  NONE: 0
  X:    1
  Y:    2
  XY:   3
  hasX: (line) -> line & Line.X
  hasY: (line) -> line & Line.Y
