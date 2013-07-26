exports.NONE  = NONE  = 0
exports.UP    = UP    = 1
exports.DOWN  = DOWN  = 2
exports.LEFT  = LEFT  = 3
exports.RIGHT = RIGHT = 4

exports.coordinates = (x, y, mate) ->
  switch mate
    when UP     then y -= 1
    when DOWN   then y += 1
    when LEFT   then x -= 1
    when RIGHT  then x += 1
  # Pack the X and Y coordinates into a single 32-bit integer
  ((x & 0xFFFF) << 16) | (y & 0xFFFF)
