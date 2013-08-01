exports.NONE          = NONE          = 0b00000000
exports.MOVE_LEFT     = MOVE_LEFT     = 0b10000000
exports.MOVE_RIGHT    = MOVE_RIGHT    = 0b01000000
exports.FLIP_LEFT     = FLIP_LEFT     = 0b00100000
exports.FLIP_RIGHT    = FLIP_RIGHT    = 0b00010000
exports.FAST_DROP     = FAST_DROP     = 0b00001000
exports.INSTANT_DROP  = INSTANT_DROP  = 0b00000100
exports.HOLD_NEXT     = HOLD_NEXT     = 0b00000010
exports.FLIP_ATTACK   = FLIP_ATTACK   = 0b00000001

exports.INSTANT_ACTIONS =
  MOVE_LEFT | MOVE_RIGHT | FLIP_LEFT | FLIP_RIGHT | INSTANT_DROP | HOLD_NEXT

exports.HOLD_ACTIONS =
  MOVE_LEFT | MOVE_RIGHT | FLIP_LEFT | FLIP_RIGHT | FAST_DROP

exports.TICK_ACTIONS =
  FAST_DROP | HOLD_NEXT | FLIP_ATTACK

exports.isNone = (input) ->
  (input | 0) is NONE

exports.get = get = (input, actionMask) ->
  # Calculating shifts is irrelevant; we just need a flag
  if input & (actionMask | 0) then 1 else 0

exports.set = set = (input, actionMask) ->
  input | actionMask

exports.clear = clear = (input, actionMask) ->
  if input and actionMask then input & ~actionMask
  else NONE

exports.normalize = normalize = (input) ->
  if (get input, MOVE_LEFT) and (get input, MOVE_RIGHT)
    input = clear input, MOVE_LEFT | MOVE_RIGHT
  if (get input, FLIP_LEFT) and (get input, FLIP_RIGHT)
    input = clear input, FLIP_LEFT | FLIP_RIGHT
  input

actionStringsToMasks =
  'None':         NONE
  'Move Left':    MOVE_LEFT
  'Move Right':   MOVE_RIGHT
  'Flip Left':    FLIP_LEFT
  'Flip Right':   FLIP_RIGHT
  'Fast Drop':    FAST_DROP
  'Instant Drop': INSTANT_DROP
  'Hold Next':    HOLD_NEXT
  'Flip Attack':  FLIP_ATTACK

actionMasksToStrings = {}
actionMasksToStrings[val] = key for key, val of actionStringsToMasks

exports.actionToString = (actionMask) ->
  actionMasksToStrings[actionMask] ? actionMasksToStrings[NONE]

exports.actionFromString = (actionString) ->
  actionStringsToMasks[actionString] ? NONE

exports.inputToString = (input) ->
  return actionMasksToStrings[NONE] if input is NONE
  inputString = ''
  actionSeparator = ', '
  for mask, string of actionMasksToStrings
    inputString += actionSeparator + string if (get input, mask)
  inputString[actionSeparator.length..]
