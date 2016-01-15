KEY_CODES_TO_SPECIAL_KEYS_MAP =
  8: 'backspace'
  9: 'tab'
  13: 'enter'
  16: 'shift'
  17: 'ctrl'
  18: 'alt'
  20: 'capslock'
  27: 'esc'
  32: 'space'
  33: 'pageup'
  34: 'pagedown'
  35: 'end'
  36: 'home'
  37: 'left'
  38: 'up'
  39: 'right'
  40: 'down'
  45: 'ins'
  46: 'del'
  91: 'meta'
  93: 'meta'
  224: 'meta'
# Function keys
KEY_CODES_TO_SPECIAL_KEYS_MAP[111 + i] = 'f' + i for i in [1...20]
# Numpad keys
KEY_CODES_TO_SPECIAL_KEYS_MAP[96 + i] = "#{i}" for i in [0..9]

SPECIAL_KEYS_TO_KEY_CODES_MAP = {}
for key, val of KEY_CODES_TO_SPECIAL_KEYS_MAP
  SPECIAL_KEYS_TO_KEY_CODES_MAP[val] = key | 0

KEY_CODES_TO_SPECIAL_CHARS_MAP =
  106: '*'
  107: '+'
  109: '-'
  110: '.'
  111 : '/'
  186: ';'
  187: '='
  188: ','
  189: '-'
  190: '.'
  191: '/'
  192: '`'
  219: '['
  220: '\\'
  221: ']'
  222: '\''

KEY_STRINGS_TO_CODES_MAP = {}
# Reverse all of the key codes except the numpad lookup (which is redundant).
for key, val of KEY_CODES_TO_SPECIAL_KEYS_MAP when 95 < key < 112
  KEY_STRINGS_TO_CODES_MAP[val] = key | 0

stringKeyCode = (str) ->
  keyCode = characterKeyCode str
  unless keyCode
    keyCode = SPECIAL_KEYS_TO_KEY_CODES_MAP[str]
  keyCode

characterKeyCode = (str) ->
  if KEY_STRINGS_TO_CODES_MAP[str]?
    KEY_STRINGS_TO_CODES_MAP[str]
  else if str.length is 1
    str.charCodeAt(0)

eventCharacter = (arg) ->
  if 'object' is typeof arg
    {type, keyCode, which} = arg
  else
    keyCode = arg
  code = if keyCode then keyCode else which
  # Key-press tells us which character was input
  # Key-down/up tells us which key was pressed
  if type is 'keypress'
    if code is KEY_CODES_TO_SPECIAL_KEYS_MAP['enter']
      '\n'
    else if code < KEY_CODES_TO_SPECIAL_KEYS_MAP['space']
      ''
    else
      String.fromCharCode code
  # Non-keypress events should interpret special keys
  else if KEY_CODES_TO_SPECIAL_KEYS_MAP[code]?
    KEY_CODES_TO_SPECIAL_KEYS_MAP[code]
  else if KEY_CODES_TO_SPECIAL_CHARS_MAP[code]?
    KEY_CODES_TO_SPECIAL_CHARS_MAP[code]
  # Non-special keys should be mapped to lower-case for consistency
  else
    (String.fromCharCode code).toLowerCase()

module.exports =
  stringKeyCode: stringKeyCode
  characterKeyCode: characterKeyCode
  eventCharacter: eventCharacter
