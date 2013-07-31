# Standard actions
exports.NONE        = NONE        = 0b00000000
exports.MOVE_LEFT   = MOVE_LEFT   = 0b10000000
exports.MOVE_RIGHT  = MOVE_RIGHT  = 0b01000000
exports.FLIP_LEFT   = FLIP_LEFT   = 0b00100000
exports.FLIP_RIGHT  = FLIP_RIGHT  = 0b00010000
exports.FAST_FALL   = FAST_FALL   = 0b00001000
# Fancy optional actions
exports.QUICK_DROP  = QUICK_DROP  = 0b00000100
exports.HOLD_NEXT   = HOLD_NEXT   = 0b00000010
exports.FLIP_ATTACK = FLIP_ATTACK = 0b00000001

exports.get = get = (input, actionMask) ->
  # Calculating shifts is irrelevant; we just need a flag
  if input & actionMask then 1 else 0

exports.set = set = (input, actionMask) ->
  input | actionMask

exports.clear = clear = (input, actionMask) ->
  if input and actionMask then input & ~actionMask
  else NONE

actionStringsToMasks =
  'None':           NONE
  'Move Left':      MOVE_LEFT
  'Move Right':     MOVE_RIGHT
  'Flip Left':      FLIP_LEFT
  'Flip Right':     FLIP_RIGHT
  'Fast Fall':      FAST_FALL
  'Quick Drop':     QUICK_DROP
  'Hold Next':      HOLD_NEXT
  'Flip Attack':    FLIP_ATTACK

actionMasksToStrings = {}
actionMasksToStrings[val] = key for key, val of actionStringsToMasks

exports.actionToString = (actionMask) ->
  actionMasksToStrings[actionMask] ? actionMasksToStrings[NONE]

exports.actionFromString = (actionString) ->
  actionStringsToMasks[actionString] ? NONE

exports.inputToString = (input) ->
  return actionMasksToStrings[NONE] if input is NONE
  inputString = ' '
  for mask, string of actionMasksToStrings
    inputString += string if (get input, mask)
  inputString[1..]
