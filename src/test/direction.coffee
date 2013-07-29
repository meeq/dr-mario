exports.NONE  = NONE  = 0
# Simple directions
exports.UP    = UP    = 1
exports.DOWN  = DOWN  = 2
exports.LEFT  = LEFT  = 3
exports.RIGHT = RIGHT = 4
# Complex directions
exports.HORIZ = HORIZ = 5
exports.VERT  = VERT  = 6
exports.CROSS = CROSS = 7

exports.isX = (direction) ->
  switch direction
    when LEFT, RIGHT, HORIZ, CROSS then true
    else false

exports.isY = (direction) ->
  switch direction
    when UP, DOWN, VERT, CROSS then true
    else false

exports.numLines = (direction) ->
  switch direction
    when HORIZ, VERT then 1
    when CROSS then 2
    else 0

exports.numDirections = (direction) ->
  switch direction
    when UP, DOWN, LEFT, RIGHT then 1
    when HORIZ, VERT then 2
    when CROSS then 4
    else 0

exports.directionAt = (direction, num) ->
  switch direction
    when UP, DOWN, LEFT, RIGHT
      if num is 0 then direction
      else NONE
    when HORIZ
      switch num
        when 0 then LEFT
        when 1 then RIGHT
        else NONE
    when VERT
      switch num
        when 0 then UP
        when 1 then DOWN
        else NONE
    when CROSS
      switch num
        when 0 then LEFT
        when 1 then RIGHT
        when 2 then UP
        when 3 then DOWN
        else NONE
    else NONE

exports.reverse = (direction) ->
  switch direction
    when LEFT   then RIGHT
    when RIGHT  then LEFT
    when UP     then DOWN
    when DOWN   then UP
    when HORIZ  then VERT
    when VERT   then HORIZ
    else direction

exports.coordinates = (x, y, direction) ->
  switch direction
    when LEFT   then x -= 1
    when RIGHT  then x += 1
    when UP     then y -= 1
    when DOWN   then y += 1
  # Pack the X and Y coordinates into a single 32-bit integer
  ((x & 0xFFFF) << 16) | (y & 0xFFFF)
