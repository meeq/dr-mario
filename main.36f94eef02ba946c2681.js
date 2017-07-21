/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 12);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

var Direction, EMPTY, colorMask, colorNames, directionMask, directionShift, getColor, getColorName, getDirection, isEmpty, isMarked, isVirus, markMask, markShift, virusMask, virusShift;

Direction = __webpack_require__(1);

exports.EMPTY = EMPTY = 0 | 0;

colorNames = ['red', 'yellow', 'blue', 'green', 'white', 'black', 'pink'];

exports.randomColor = function(numColors) {
  if (numColors == null) {
    numColors = colorNames.length;
  }
  numColors = numColors | 0;
  return (1 + (Math.random() * numColors)) | 0;
};

exports.isEmpty = isEmpty = function(cell) {
  cell = cell | 0;
  return cell === EMPTY;
};

colorMask = 0x7;

exports.getColor = getColor = function(cell) {
  cell = cell | 0;
  return (cell & colorMask) | 0;
};

exports.getColorName = getColorName = function(cell) {
  cell = cell | 0;
  return colorNames[(getColor(cell)) - 1];
};

virusMask = 0x80;

virusShift = (Math.log(virusMask) / Math.LN2) | 0;

exports.isVirus = isVirus = function(cell) {
  cell = cell | 0;
  return ((cell & virusMask) >>> virusShift) | 0;
};

exports.setVirus = function(cell) {
  cell = cell | 0;
  return (cell | virusMask) | 0;
};

markMask = 0x40;

markShift = (Math.log(markMask) / Math.LN2) | 0;

exports.isMarked = isMarked = function(cell) {
  cell = cell | 0;
  return ((cell & markMask) >>> markShift) | 0;
};

exports.setMark = function(cell) {
  cell = cell | 0;
  return (cell | markMask) | 0;
};

directionMask = 0x38;

directionShift = ((Math.log(directionMask) / Math.LN2) - 2) | 0;

exports.getDirection = getDirection = function(cell) {
  cell = cell | 0;
  return ((cell & directionMask) >>> directionShift) | 0;
};

exports.setDirection = function(cell, direction) {
  cell = cell | 0;
  direction = direction | 0;
  cell = (cell & ~directionMask) | 0;
  if (direction) {
    cell = (cell | (direction << directionShift)) | 0;
  }
  return cell | 0;
};

exports.getClassName = function(cell) {
  var className, direction;
  if (isEmpty(cell)) {
    className = 'empty';
  } else {
    className = getColorName(cell);
    if (isMarked(cell)) {
      className += ' marked';
    } else if (isVirus(cell)) {
      className += ' virus';
    } else {
      className += ' pill';
      direction = getDirection(cell);
      if (direction === Direction.UP) {
        className += ' up';
      } else if (direction === Direction.DOWN) {
        className += ' down';
      } else if (direction === Direction.LEFT) {
        className += ' left';
      } else if (direction === Direction.RIGHT) {
        className += ' right';
      }
    }
  }
  return className;
};


/***/ }),
/* 1 */
/***/ (function(module, exports) {

var CROSS, DOWN, HORIZ, LEFT, NONE, RIGHT, UP, VERT, reverse, rotateLeft, rotateRight;

exports.NONE = NONE = 0 | 0;

exports.UP = UP = 1 | 0;

exports.DOWN = DOWN = 2 | 0;

exports.LEFT = LEFT = 3 | 0;

exports.RIGHT = RIGHT = 4 | 0;

exports.HORIZ = HORIZ = 5 | 0;

exports.VERT = VERT = 6 | 0;

exports.CROSS = CROSS = 7 | 0;

exports.isX = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case LEFT:
    case RIGHT:
    case HORIZ:
    case CROSS:
      return true;
    default:
      return false;
  }
};

exports.isY = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case UP:
    case DOWN:
    case VERT:
    case CROSS:
      return true;
    default:
      return false;
  }
};

exports.numLines = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case HORIZ:
    case VERT:
      return 1 | 0;
    case CROSS:
      return 2 | 0;
    default:
      return 0 | 0;
  }
};

exports.numDirections = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case UP:
    case DOWN:
    case LEFT:
    case RIGHT:
      return 1 | 0;
    case HORIZ:
    case VERT:
      return 2 | 0;
    case CROSS:
      return 4 | 0;
    default:
      return 0 | 0;
  }
};

exports.directionAt = function(direction, num) {
  direction = direction | 0;
  num = num | 0;
  switch (direction) {
    case UP:
    case DOWN:
    case LEFT:
    case RIGHT:
      if (num === 0) {
        return direction;
      } else {
        return NONE;
      }
      break;
    case HORIZ:
      switch (num) {
        case 0:
          return LEFT;
        case 1:
          return RIGHT;
        default:
          return NONE;
      }
      break;
    case VERT:
      switch (num) {
        case 0:
          return UP;
        case 1:
          return DOWN;
        default:
          return NONE;
      }
      break;
    case CROSS:
      switch (num) {
        case 0:
          return LEFT;
        case 1:
          return RIGHT;
        case 2:
          return UP;
        case 3:
          return DOWN;
        default:
          return NONE;
      }
      break;
    default:
      return NONE;
  }
};

exports.reverse = reverse = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case LEFT:
      return RIGHT;
    case RIGHT:
      return LEFT;
    case UP:
      return DOWN;
    case DOWN:
      return UP;
    case HORIZ:
      return VERT;
    case VERT:
      return HORIZ;
    default:
      return direction;
  }
};

exports.rotateLeft = rotateLeft = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case LEFT:
      return DOWN;
    case RIGHT:
      return UP;
    case UP:
      return LEFT;
    case DOWN:
      return RIGHT;
    default:
      return reverse(direction);
  }
};

exports.rotateRight = rotateRight = function(direction) {
  direction = direction | 0;
  switch (direction) {
    case LEFT:
      return UP;
    case RIGHT:
      return DOWN;
    case UP:
      return RIGHT;
    case DOWN:
      return LEFT;
    default:
      return reverse(direction);
  }
};

exports.rotate = function(direction, rotateDirection) {
  direction = direction | 0;
  rotateDirection = rotateDirection | 0;
  switch (rotateDirection) {
    case LEFT:
      return rotateLeft(direction);
    case RIGHT:
      return rotateRight(direction);
    case UP:
      return rotateLeft(rotateLeft(direction));
    case DOWN:
      return rotateRight(rotateRight(direction));
    default:
      return direction;
  }
};

exports.unset = function(directions, direction) {
  directions = directions | 0;
  direction = direction | 0;
  if (directions === direction) {
    return NONE;
  } else {
    switch (directions) {
      case HORIZ:
        switch (direction) {
          case LEFT:
            return RIGHT;
          case RIGHT:
            return LEFT;
          default:
            return directions;
        }
        break;
      case VERT:
        switch (direction) {
          case UP:
            return DOWN;
          case DOWN:
            return UP;
          default:
            return directions;
        }
        break;
      case CROSS:
        switch (direction) {
          case HORIZ:
            return VERT;
          case VERT:
            return HORIZ;
          default:
            return directions;
        }
        break;
      default:
        return directions;
    }
  }
};

exports.coordinates = function(x, y, direction) {
  x = x | 0;
  y = y | 0;
  direction = direction | 0;
  switch (direction) {
    case LEFT:
      x -= 1;
      break;
    case RIGHT:
      x += 1;
      break;
    case UP:
      y -= 1;
      break;
    case DOWN:
      y += 1;
  }
  return ((x & 0xFFFF) << 16) | (y & 0xFFFF);
};


/***/ }),
/* 2 */
/***/ (function(module, exports) {

var KEY_CODES_TO_SPECIAL_CHARS_MAP, KEY_CODES_TO_SPECIAL_KEYS_MAP, KEY_STRINGS_TO_CODES_MAP, SPECIAL_KEYS_TO_KEY_CODES_MAP, characterKeyCode, eventCharacter, i, j, k, key, stringKeyCode, val;

KEY_CODES_TO_SPECIAL_KEYS_MAP = {
  8: 'backspace',
  9: 'tab',
  13: 'enter',
  16: 'shift',
  17: 'ctrl',
  18: 'alt',
  20: 'capslock',
  27: 'esc',
  32: 'space',
  33: 'pageup',
  34: 'pagedown',
  35: 'end',
  36: 'home',
  37: 'left',
  38: 'up',
  39: 'right',
  40: 'down',
  45: 'ins',
  46: 'del',
  91: 'meta',
  93: 'meta',
  224: 'meta'
};

for (i = j = 1; j < 20; i = ++j) {
  KEY_CODES_TO_SPECIAL_KEYS_MAP[111 + i] = 'f' + i;
}

for (i = k = 0; k <= 9; i = ++k) {
  KEY_CODES_TO_SPECIAL_KEYS_MAP[96 + i] = "" + i;
}

SPECIAL_KEYS_TO_KEY_CODES_MAP = {};

for (key in KEY_CODES_TO_SPECIAL_KEYS_MAP) {
  val = KEY_CODES_TO_SPECIAL_KEYS_MAP[key];
  SPECIAL_KEYS_TO_KEY_CODES_MAP[val] = key | 0;
}

KEY_CODES_TO_SPECIAL_CHARS_MAP = {
  106: '*',
  107: '+',
  109: '-',
  110: '.',
  111: '/',
  186: ';',
  187: '=',
  188: ',',
  189: '-',
  190: '.',
  191: '/',
  192: '`',
  219: '[',
  220: '\\',
  221: ']',
  222: '\''
};

KEY_STRINGS_TO_CODES_MAP = {};

for (key in KEY_CODES_TO_SPECIAL_KEYS_MAP) {
  val = KEY_CODES_TO_SPECIAL_KEYS_MAP[key];
  if ((95 < key && key < 112)) {
    KEY_STRINGS_TO_CODES_MAP[val] = key | 0;
  }
}

stringKeyCode = function(str) {
  var keyCode;
  keyCode = characterKeyCode(str);
  if (!keyCode) {
    keyCode = SPECIAL_KEYS_TO_KEY_CODES_MAP[str];
  }
  return keyCode;
};

characterKeyCode = function(str) {
  if (KEY_STRINGS_TO_CODES_MAP[str] != null) {
    return KEY_STRINGS_TO_CODES_MAP[str];
  } else if (str.length === 1) {
    return str.charCodeAt(0);
  }
};

eventCharacter = function(arg) {
  var code, keyCode, type, which;
  if ('object' === typeof arg) {
    type = arg.type, keyCode = arg.keyCode, which = arg.which;
  } else {
    keyCode = arg;
  }
  code = keyCode ? keyCode : which;
  if (type === 'keypress') {
    if (code === KEY_CODES_TO_SPECIAL_KEYS_MAP['enter']) {
      return '\n';
    } else if (code < KEY_CODES_TO_SPECIAL_KEYS_MAP['space']) {
      return '';
    } else {
      return String.fromCharCode(code);
    }
  } else if (KEY_CODES_TO_SPECIAL_KEYS_MAP[code] != null) {
    return KEY_CODES_TO_SPECIAL_KEYS_MAP[code];
  } else if (KEY_CODES_TO_SPECIAL_CHARS_MAP[code] != null) {
    return KEY_CODES_TO_SPECIAL_CHARS_MAP[code];
  } else {
    return (String.fromCharCode(code)).toLowerCase();
  }
};

module.exports = {
  stringKeyCode: stringKeyCode,
  characterKeyCode: characterKeyCode,
  eventCharacter: eventCharacter
};


/***/ }),
/* 3 */
/***/ (function(module, exports) {

var FAST_DROP, FLIP_ATTACK, FLIP_LEFT, FLIP_RIGHT, INSTANT_DROP, MOVE_LEFT, MOVE_RIGHT, NONE, SWAP_HOLD, actionMasksToStrings, actionStringsToMasks, clear, get, key, normalize, set, val;

exports.NONE = NONE = 0x0;

exports.MOVE_LEFT = MOVE_LEFT = 0x80;

exports.MOVE_RIGHT = MOVE_RIGHT = 0x40;

exports.FLIP_LEFT = FLIP_LEFT = 0x20;

exports.FLIP_RIGHT = FLIP_RIGHT = 0x10;

exports.FAST_DROP = FAST_DROP = 0x8;

exports.INSTANT_DROP = INSTANT_DROP = 0x4;

exports.SWAP_HOLD = SWAP_HOLD = 0x2;

exports.FLIP_ATTACK = FLIP_ATTACK = 0x1;

exports.MOVE_ACTIONS = MOVE_LEFT | MOVE_RIGHT;

exports.HOLD_ACTIONS = MOVE_LEFT | MOVE_RIGHT | FAST_DROP;

exports.PRESS_ACTIONS = FLIP_LEFT | FLIP_RIGHT | INSTANT_DROP | SWAP_HOLD | FLIP_ATTACK;

exports.isNone = function(input) {
  return (input | 0) === NONE;
};

exports.get = get = function(input, actionMask) {
  if (input & (actionMask | 0)) {
    return 1;
  } else {
    return 0;
  }
};

exports.set = set = function(input, actionMask) {
  return input | actionMask;
};

exports.clear = clear = function(input, actionMask) {
  if (input && actionMask) {
    return input & ~actionMask;
  } else {
    return NONE;
  }
};

exports.normalize = normalize = function(input) {
  if ((get(input, MOVE_LEFT)) && (get(input, MOVE_RIGHT))) {
    input = clear(input, MOVE_LEFT | MOVE_RIGHT);
  }
  if ((get(input, FLIP_LEFT)) && (get(input, FLIP_RIGHT))) {
    input = clear(input, FLIP_LEFT | FLIP_RIGHT);
  }
  return input;
};

actionStringsToMasks = {
  'None': NONE,
  'Move Left': MOVE_LEFT,
  'Move Right': MOVE_RIGHT,
  'Flip Left': FLIP_LEFT,
  'Flip Right': FLIP_RIGHT,
  'Fast Drop': FAST_DROP,
  'Instant Drop': INSTANT_DROP,
  'Hold Next': SWAP_HOLD,
  'Flip Attack': FLIP_ATTACK
};

actionMasksToStrings = {};

for (key in actionStringsToMasks) {
  val = actionStringsToMasks[key];
  actionMasksToStrings[val] = key;
}

exports.actionToString = function(actionMask) {
  var ref;
  return (ref = actionMasksToStrings[actionMask]) != null ? ref : actionMasksToStrings[NONE];
};

exports.actionFromString = function(actionString) {
  var ref;
  return (ref = actionStringsToMasks[actionString]) != null ? ref : NONE;
};

exports.inputToString = function(input) {
  var actionSeparator, inputString, mask, string;
  if (input === NONE) {
    return actionMasksToStrings[NONE];
  }
  inputString = '';
  actionSeparator = ', ';
  for (mask in actionMasksToStrings) {
    string = actionMasksToStrings[mask];
    if (get(input, mask)) {
      inputString += actionSeparator + string;
    }
  }
  return inputString.slice(actionSeparator.length);
};


/***/ }),
/* 4 */
/***/ (function(module, exports) {

var HI, LO, MED, options;

exports.LO = LO = 0 | 0;

exports.MED = MED = 1 | 0;

exports.HI = HI = 2 | 0;

exports.options = options = ['lo', 'med', 'hi'];

exports.fromOption = function(speedOption) {
  var index;
  if (0 <= (index = options.indexOf(speedOption))) {
    return index | 0;
  }
};

exports.calculateTickRate = function(speed, count) {
  var base, index;
  speed = speed | 0;
  count = count | 0;
  switch (speed) {
    case LO:
      base = 15 | 0;
      break;
    case MED:
      base = 25 | 0;
      break;
    case HI:
      base = 31 | 0;
  }
  index = (base + count) | 0;
  if (index <= 25) {
    return ((35 - index) * 2 - 1) | 0;
  } else if (index <= 34) {
    return (44 - index) | 0;
  } else if (index <= 36) {
    return 9 | 0;
  } else if (index <= 38) {
    return 8 | 0;
  } else if (index <= 40) {
    return 7 | 0;
  } else if (index <= 42) {
    return 6 | 0;
  } else if (index <= 54) {
    return 5 | 0;
  } else if (index <= 59) {
    return 4 | 0;
  } else if (index <= 64) {
    return 3 | 0;
  } else if (index <= 69) {
    return 2 | 0;
  } else {
    return 1 | 0;
  }
};

exports.baseScoreCombo = function(speed) {
  speed = speed | 0;
  switch (speed) {
    case LO:
      return 1 | 0;
    case MED:
      return 2 | 0;
    case HI:
      return 3 | 0;
  }
};


/***/ }),
/* 5 */
/***/ (function(module, exports) {

var INTERVAL, REQUEST_FRAME, TIMEOUT, cancelAnimationFrame, hiResNow, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, requestAnimationFrame;

requestAnimationFrame = (ref1 = (ref2 = (ref3 = (ref4 = (ref5 = window.requestAnimationFrame) != null ? ref5 : window.webkitRequestAnimationFrame) != null ? ref4 : window.mozRequestAnimationFrame) != null ? ref3 : window.oRequestAnimationFrame) != null ? ref2 : window.msRequestAnimationFrame) != null ? ref1 : null;

cancelAnimationFrame = (ref6 = (ref7 = (ref8 = (ref9 = (ref10 = window.cancelAnimationFrame) != null ? ref10 : window.webkitCancelAnimationFrame) != null ? ref9 : window.mozCancelAnimationFrame) != null ? ref8 : window.oCancelAnimationFrame) != null ? ref7 : window.msCancelAnimationFrame) != null ? ref6 : null;

if (typeof performance !== "undefined" && performance !== null) {
  hiResNow = (ref11 = (ref12 = (ref13 = (ref14 = performance.now) != null ? ref14 : performance.mozNow) != null ? ref13 : performance.msNow) != null ? ref12 : performance.oNow) != null ? ref11 : performance.webkitNow;
}

if (hiResNow != null) {
  exports.now = hiResNow.bind(performance);
} else {
  exports.now = (ref15 = Date.now) != null ? ref15 : function() {
    return new Date().getTime();
  };
}

exports.TIMEOUT = TIMEOUT = 0;

exports.INTERVAL = INTERVAL = 1;

exports.REQUEST_FRAME = REQUEST_FRAME = 2;

exports.isRepeating = function(method) {
  switch (method) {
    case TIMEOUT:
      return false;
    case INTERVAL:
      return true;
    case REQUEST_FRAME:
      return false;
  }
};

exports.start = function(method, callback, interval) {
  switch (method) {
    case TIMEOUT:
      return setTimeout(callback, interval);
    case INTERVAL:
      return setInterval(callback, interval);
    case REQUEST_FRAME:
      if (requestAnimationFrame != null) {
        return requestAnimationFrame(callback);
      } else {
        return setTimeout(callback, interval);
      }
  }
};

exports.stop = function(method, ref) {
  switch (method) {
    case TIMEOUT:
      clearTimeout(ref);
      break;
    case INTERVAL:
      clearInterval(ref);
      break;
    case REQUEST_FRAME:
      if (cancelAnimationFrame != null) {
        cancelAnimationFrame(ref);
      } else {
        clearTimeout(ref);
      }
  }
};


/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

var Cell, Direction, Matrix;

Cell = __webpack_require__(0);

Direction = __webpack_require__(1);

module.exports = Matrix = (function() {
  Matrix.prototype.supportsTypedArrays = (window.ArrayBuffer != null) && (window.Uint8ClampedArray != null);

  function Matrix(options) {
    var cellBuffer, numCells;
    this.width = options.width, this.height = options.height, this.lineLength = options.lineLength;
    numCells = this.width * this.height;
    if (this.supportsTypedArrays) {
      cellBuffer = new ArrayBuffer(numCells);
      this.cells = new Uint8ClampedArray(cellBuffer);
    } else {
      this.cells = [];
      this.cells.length = numCells;
    }
    return;
  }

  Matrix.prototype.get = function(x, y) {
    x = x | 0;
    y = y | 0;
    if (x < 0 || x >= this.width || y < 0 || y >= this.height) {
      return;
    }
    return this.cells[x + (y * this.width)] | 0;
  };

  Matrix.prototype.set = function(x, y, value) {
    x = x | 0;
    y = y | 0;
    value = value | 0;
    if (x < 0 || x >= this.width || y < 0 || y >= this.height) {
      return;
    }
    return this.cells[x + (y * this.width)] = value | 0;
  };

  Matrix.prototype.clear = function(x, y) {
    var cell, i, j, len, ref;
    if ((x != null) && (y != null)) {
      return this.set(x, y, Cell.EMPTY);
    } else {
      ref = this.cells;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        cell = ref[i];
        this.cells[i] = Cell.EMPTY;
      }
    }
  };

  Matrix.prototype.isClear = function(x, y) {
    var j, k, ref, ref1;
    if ((x != null) && (y != null)) {
      return Cell.isEmpty(this.get(x, y));
    } else {
      for (x = j = 0, ref = this.width; 0 <= ref ? j < ref : j > ref; x = 0 <= ref ? ++j : --j) {
        for (y = k = ref1 = this.height - 1; ref1 <= 0 ? k <= 0 : k >= 0; y = ref1 <= 0 ? ++k : --k) {
          if (!Cell.isEmpty(this.get(x, y))) {
            return false;
          }
        }
      }
      return true;
    }
  };

  Matrix.prototype.count = function(sampleCell) {
    var cell, j, len, ref, result;
    result = 0;
    ref = this.cells;
    for (j = 0, len = ref.length; j < len; j++) {
      cell = ref[j];
      if (cell === sampleCell) {
        result += 1;
      }
    }
    return result;
  };

  Matrix.prototype.mark = function(x, y) {
    return this.set(x, y, Cell.setMark(this.get(x, y)));
  };

  Matrix.prototype.checkLineDirections = function(originX, originY) {
    originX = originX | 0;
    originY = originY | 0;
    return this.markLineDirections(originX, originY, Direction.NONE);
  };

  Matrix.prototype.markLineDirections = function(originX, originY, markDirections) {
    var cell, cellColor, downMatches, isHorizontalLine, isVerticalLine, leftMatches, rightMatches, testCell, testX, testY, upMatches;
    originX = originX | 0;
    originY = originY | 0;
    cell = this.get(originX, originY);
    cellColor = Cell.getColor(cell);
    if (!cellColor || (this.isFalling(originX, originY)) || Cell.isMarked(cell)) {
      return Direction.NONE;
    }
    if (markDirections) {
      this.mark(originX, originY);
    }
    testX = originX - 1;
    leftMatches = 0;
    while (testX >= 0) {
      testCell = this.get(testX, originY);
      if (cellColor !== Cell.getColor(testCell)) {
        break;
      }
      if (Direction.isX(markDirections)) {
        this.mark(testX, originY);
      }
      leftMatches += 1;
      testX -= 1;
    }
    testX = originX + 1;
    rightMatches = 0;
    while (testX < this.width) {
      testCell = this.get(testX, originY);
      if (cellColor !== Cell.getColor(testCell)) {
        break;
      }
      if (Direction.isX(markDirections)) {
        this.mark(testX, originY);
      }
      rightMatches += 1;
      testX += 1;
    }
    testY = originY - 1;
    upMatches = 0;
    while (testY >= 0) {
      testCell = this.get(originX, testY);
      if (cellColor !== Cell.getColor(testCell)) {
        break;
      }
      if (Direction.isY(markDirections)) {
        this.mark(originX, testY);
      }
      upMatches += 1;
      testY -= 1;
    }
    testY = originY + 1;
    downMatches = 0;
    while (testY < this.height) {
      testCell = this.get(originX, testY);
      if (cellColor !== Cell.getColor(testCell)) {
        break;
      }
      if (Direction.isY(markDirections)) {
        this.mark(originX, testY);
      }
      downMatches += 1;
      testY += 1;
    }
    isHorizontalLine = 1 + leftMatches + rightMatches >= this.lineLength;
    isVerticalLine = 1 + upMatches + downMatches >= this.lineLength;
    if (isHorizontalLine && isVerticalLine) {
      return Direction.CROSS;
    } else if (isHorizontalLine) {
      return Direction.HORIZ;
    } else if (isVerticalLine) {
      return Direction.VERT;
    } else {
      return Direction.NONE;
    }
  };

  Matrix.prototype.isFalling = function(originX, originY, checkDirection) {
    var cell, coordinates, direction, directions, i, isFalling, j, neighborX, neighborY, ref;
    if (checkDirection == null) {
      checkDirection = true;
    }
    originX = originX | 0;
    originY = originY | 0;
    cell = this.get(originX, originY);
    if ((originY >= this.height - 1) || (Cell.isEmpty(cell)) || (Cell.isVirus(cell))) {
      return false;
    } else if (Cell.isEmpty(this.get(originX, originY + 1))) {
      if (checkDirection && (directions = Cell.getDirection(cell))) {
        isFalling = true;
        for (i = j = 0, ref = Direction.numDirections(directions); 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          direction = Direction.directionAt(directions, i);
          if (direction === Direction.UP) {
            continue;
          }
          coordinates = Direction.coordinates(originX, originY, direction);
          neighborX = coordinates >>> 16;
          neighborY = coordinates & 0xFFFF;
          isFalling = isFalling && this.isFalling(neighborX, neighborY, false);
        }
        return isFalling;
      } else {
        return true;
      }
    } else {
      return false;
    }
  };

  Matrix.prototype.drop = function(x, y) {
    var cell;
    x = x | 0;
    y = y | 0;
    cell = this.get(x, y);
    this.clear(x, y);
    this.set(x, y + 1, cell);
  };

  Matrix.prototype.dropFalling = function() {
    var cell, coordinates, direction, j, k, neighborX, neighborY, ref, ref1, totalDropped, x, y;
    totalDropped = 0;
    for (x = j = 0, ref = this.width; 0 <= ref ? j < ref : j > ref; x = 0 <= ref ? ++j : --j) {
      for (y = k = ref1 = this.height - 2; ref1 <= 0 ? k <= 0 : k >= 0; y = ref1 <= 0 ? ++k : --k) {
        if (this.isFalling(x, y)) {
          cell = this.get(x, y);
          this.drop(x, y);
          totalDropped += 1;
          if ((direction = Cell.getDirection(cell))) {
            coordinates = Direction.coordinates(x, y, direction);
            neighborX = coordinates >>> 16;
            neighborY = coordinates & 0xFFFF;
            if (neighborX !== x || neighborY !== y) {
              this.drop(neighborX, neighborY);
              totalDropped += 1;
            }
          }
        }
      }
    }
    return totalDropped;
  };

  Matrix.prototype.markLines = function() {
    var j, k, lines, ref, ref1, totalMarked, x, y;
    totalMarked = 0;
    for (x = j = 0, ref = this.width; 0 <= ref ? j < ref : j > ref; x = 0 <= ref ? ++j : --j) {
      for (y = k = 0, ref1 = this.height; 0 <= ref1 ? k < ref1 : k > ref1; y = 0 <= ref1 ? ++k : --k) {
        if ((lines = this.checkLineDirections(x, y))) {
          this.markLineDirections(x, y, lines);
          totalMarked += Direction.numLines(lines);
        }
      }
    }
    return totalMarked;
  };

  Matrix.prototype.reshape = function(x, y) {
    var cell, coordinates, direction, directions, i, j, neighborX, neighborY, newDirection, ref;
    x = x | 0;
    y = y | 0;
    cell = this.get(x, y);
    newDirection = directions = Cell.getDirection(cell);
    for (i = j = 0, ref = Direction.numDirections(directions); 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      direction = Direction.directionAt(directions, i);
      coordinates = Direction.coordinates(x, y, direction);
      neighborX = coordinates >>> 16;
      neighborY = coordinates & 0xFFFF;
      if (Cell.isEmpty(this.get(neighborX, neighborY))) {
        newDirection = Direction.unset(newDirection, direction);
      }
    }
    if (newDirection !== directions) {
      this.set(x, y, Cell.setDirection(cell, newDirection));
    }
  };

  Matrix.prototype.clearMarked = function() {
    var cell, coordinates, direction, directions, i, j, k, l, neighborX, neighborY, ref, ref1, ref2, totalCleared, totalViruses, x, y;
    totalCleared = 0;
    totalViruses = 0;
    for (x = j = 0, ref = this.width; 0 <= ref ? j < ref : j > ref; x = 0 <= ref ? ++j : --j) {
      for (y = k = 0, ref1 = this.height; 0 <= ref1 ? k < ref1 : k > ref1; y = 0 <= ref1 ? ++k : --k) {
        cell = this.get(x, y);
        if (Cell.isMarked(cell)) {
          this.clear(x, y);
          totalCleared += 1;
          if (Cell.isVirus(cell)) {
            totalViruses += 1;
          }
          directions = Cell.getDirection(cell);
          for (i = l = 0, ref2 = Direction.numDirections(directions); 0 <= ref2 ? l < ref2 : l > ref2; i = 0 <= ref2 ? ++l : --l) {
            direction = Direction.directionAt(directions, i);
            coordinates = Direction.coordinates(x, y, direction);
            neighborX = coordinates >>> 16;
            neighborY = coordinates & 0xFFFF;
            this.reshape(neighborX, neighborY);
          }
        }
      }
    }
    return ((totalViruses & 0xFFFF) << 16) | (totalCleared & 0xFFFF);
  };

  return Matrix;

})();


/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

var Cell, PlayerMatrixView;

Cell = __webpack_require__(0);

module.exports = PlayerMatrixView = (function() {
  function PlayerMatrixView(arg) {
    var ref, ref1;
    this.state = arg.state, this.buffer = arg.buffer;
    ref1 = (ref = this.state) != null ? ref : this.buffer, this.width = ref1.width, this.height = ref1.height;
    return;
  }

  PlayerMatrixView.prototype.render = function() {
    var i, j, ref, ref1, tr, x, y;
    this.el = document.createElement('table');
    this.el.className = 'player-matrix';
    this.cellEls = [];
    for (y = i = 0, ref = this.height; 0 <= ref ? i < ref : i > ref; y = 0 <= ref ? ++i : --i) {
      tr = document.createElement('tr');
      for (x = j = 0, ref1 = this.width; 0 <= ref1 ? j < ref1 : j > ref1; x = 0 <= ref1 ? ++j : --j) {
        tr.appendChild(this.renderCell(x, y));
      }
      this.el.appendChild(tr);
    }
    this.update();
    return this.el;
  };

  PlayerMatrixView.prototype.renderCell = function(x, y) {
    var cellEl, ref;
    cellEl = document.createElement('td');
    cellEl.dataset.x = x;
    cellEl.dataset.y = y;
    if ((ref = this.cellEls) != null) {
      ref.push(cellEl);
    }
    return cellEl;
  };

  PlayerMatrixView.prototype.destroy = function() {
    var ref, ref1;
    if ((ref = this.el) != null) {
      if ((ref1 = ref.parentNode) != null) {
        ref1.removeChild(this.el);
      }
    }
    delete this.cellEls;
    delete this.el;
  };

  PlayerMatrixView.prototype.update = function() {
    var className, i, len, ref, td, x, y;
    if (this.cellEls != null) {
      ref = this.cellEls;
      for (i = 0, len = ref.length; i < len; i++) {
        td = ref[i];
        x = td.dataset.x | 0;
        y = td.dataset.y | 0;
        className = this.getClassNameForCell(x, y);
        if (td.className !== className) {
          td.className = className;
        }
      }
    }
  };

  PlayerMatrixView.prototype.getClassNameForCell = function(x, y) {
    var cell, ref, ref1;
    cell = Cell.EMPTY;
    if (this.state != null) {
      cell = (ref = this.state.capsule) != null ? ref.get(x, y) : void 0;
      if (Cell.isEmpty(cell)) {
        cell = (ref1 = this.state.grid) != null ? ref1.get(x, y) : void 0;
      }
    } else if (this.buffer != null) {
      cell = this.buffer.get(x, y);
    }
    return Cell.getClassName(cell);
  };

  return PlayerMatrixView;

})();


/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

var App, GameView, SetupView, Sound;

SetupView = __webpack_require__(22);

GameView = __webpack_require__(16);

Sound = __webpack_require__(23);

module.exports = App = (function() {
  function App() {}

  App.prototype.baseEl = document.body;

  App.prototype.start = function() {
    this.detectBrowser();
    this.sound = new Sound;
    if (this.sound.audioCtx != null) {
      this.sound.loadAll();
    } else {
      delete this.sound;
    }
    this.showSetup();
  };

  App.prototype.cleanup = function() {
    if (this.setup != null) {
      this.setup.destroy();
      delete this.setup;
    }
    if (this.game != null) {
      this.game.destroy();
      delete this.game;
    }
  };

  App.prototype.showSetup = function() {
    this.cleanup();
    this.setup = new SetupView({
      app: this,
      numPlayers: 1
    });
    this.baseEl.appendChild(this.setup.render());
  };

  App.prototype.startGame = function(options) {
    this.cleanup();
    options.app = this;
    this.game = new GameView(options);
    this.baseEl.appendChild(this.game.render());
    this.game.unpause();
  };

  App.prototype.detectBrowser = function() {
    var isAndroidMobileDevice, isAppleMobileDevice, isGoogleChrome, isMozillaFirefox, userAgent, vendor;
    userAgent = navigator.userAgent, vendor = navigator.vendor;
    isMozillaFirefox = /firefox/i.test(userAgent);
    isGoogleChrome = (/Chrome/.test(userAgent)) && (/Google Inc/.test(vendor));
    isAppleMobileDevice = (/AppleWebKit/.test(userAgent)) && (/(iPod|iPhone|iPad)/.test(userAgent));
    isAndroidMobileDevice = /android/i.test(userAgent);
    this.isTouchDevice = isAppleMobileDevice || isAndroidMobileDevice;
    this.isGamepadSupported = navigator.getGamepads != null;
    if (this.isTouchDevice) {
      this.disableBodyScrolling();
    }
    if (isMozillaFirefox) {
      this.baseEl.className += " mozilla-firefox";
    } else if (isGoogleChrome) {
      this.baseEl.className += " google-chrome";
    }
  };

  App.prototype.disableBodyScrolling = function() {
    document.addEventListener('touchmove', function(event) {
      if (event.target.tagName === 'INPUT') {
        return;
      }
      event.preventDefault();
    });
  };

  return App;

})();


/***/ }),
/* 9 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 10 */
/***/ (function(module, exports) {

var appCacheIframe;

function hasSW() {
  return 'serviceWorker' in navigator &&
    // This is how I block Chrome 40 and detect Chrome 41, because first has
    // bugs with history.pustState and/or hashchange
    (window.fetch || 'imageRendering' in document.documentElement.style) &&
    (window.location.protocol === 'https:' || window.location.hostname === 'localhost')
}

function install(options) {
  options || (options = {});

  
    if (hasSW()) {
      var registration = navigator.serviceWorker
        .register(
          "sw.js"
          
        );

      

      return;
    }
  

  
    if (window.applicationCache) {
      var directory = "appcache/";
      var name = "manifest";

      var doLoad = function() {
        var page = directory + name + '.html';
        var iframe = document.createElement('iframe');

        

        iframe.src = page;
        iframe.style.display = 'none';

        appCacheIframe = iframe;
        document.body.appendChild(iframe);
      };

      if (document.readyState === 'complete') {
        setTimeout(doLoad);
      } else {
        window.addEventListener('load', doLoad);
      }

      return;
    }
  
}

function applyUpdate(callback, errback) {
  

  
}

function update() {
  
    if (hasSW()) {
      navigator.serviceWorker.getRegistration().then(function(registration) {
        if (!registration) return;
        return registration.update();
      });
    }
  

  
    if (appCacheIframe) {
      try {
        appCacheIframe.contentWindow.applicationCache.update();
      } catch (e) {}
    }
  
}



exports.install = install;
exports.applyUpdate = applyUpdate;
exports.update = update;


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

var keyCodeControl, stringKeyCode;

stringKeyCode = __webpack_require__(2).stringKeyCode;

exports.keyCodeControl = keyCodeControl = function(keyCode) {
  if (typeof keyCode === 'string') {
    keyCode = stringKeyCode(keyCode);
  }
  return {
    type: 'keyCode',
    keyCode: keyCode
  };
};

exports.gamepadButtonControl = function(gamepadIndex, buttonIndex) {
  return {
    type: 'gamepadButton',
    gamepadIndex: gamepadIndex,
    buttonIndex: buttonIndex
  };
};

exports.player = function(playerName) {
  return {
    level: 10,
    speed: 'med',
    controls: {
      'Move Left': keyCodeControl('left'),
      'Move Right': keyCodeControl('right'),
      'Flip Left': keyCodeControl('Z'),
      'Flip Right': keyCodeControl('X'),
      'Fast Drop': keyCodeControl('down'),
      'Instant Drop': keyCodeControl('up')
    }
  };
};


/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

var App, app;

(__webpack_require__(10)).install();

__webpack_require__(9);

App = __webpack_require__(8);

app = new App;

app.start();


/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

var Capsule, Cell, Direction, Matrix;

Cell = __webpack_require__(0);

Direction = __webpack_require__(1);

Matrix = __webpack_require__(6);

module.exports = Capsule = (function() {
  function Capsule(player) {
    var ref;
    this.player = player;
    ref = this.player, this.grid = ref.grid, this.game = ref.game;
    this.width = this.height = this.size = this.player.capsuleSize;
    this.x = this.startX = Math.round((this.player.width / 2) - (this.size / 2));
    this.y = this.startY = -this.size + 1;
    this.fallingBuffer = new Matrix(this);
    this.rotateBuffer = new Matrix(this);
    this.nextBuffer = new Matrix(this);
    return;
  }

  Capsule.prototype.generate = function() {
    this.x = this.startX;
    this.y = this.startY;
    if (this.nextBuffer.isClear()) {
      this.random(this.fallingBuffer);
    } else {
      this.blit(this.nextBuffer, this.fallingBuffer);
    }
    this.random(this.nextBuffer);
  };

  Capsule.prototype.get = function(x, y) {
    var isInX, isInY;
    x = x | 0;
    y = y | 0;
    isInX = x >= this.x && x < (this.x + this.size);
    isInY = y >= this.y && y < (this.y + this.size);
    if (isInX && isInY) {
      return this.fallingBuffer.get(x - this.x, y - this.y);
    } else {
      return Cell.EMPTY;
    }
  };

  Capsule.prototype.isFalling = function() {
    return !this.fallingBuffer.isClear();
  };

  Capsule.prototype.isLanded = function() {
    if (this.y >= this.player.height - 1) {
      return true;
    } else {
      return this.checkCollision(this.x, this.y + 1);
    }
  };

  Capsule.prototype.isOutOfBounds = function() {
    return this.y <= this.startY && this.x === this.startX && this.checkCollision();
  };

  Capsule.prototype.drop = function() {
    if (!this.isLanded()) {
      this.y += 1;
      if (this.isLanded()) {
        this.landedTick = this.player.tickCount;
      } else {
        delete this.landedTick;
      }
    } else {
      if (this.landedTick == null) {
        this.landedTick = this.player.tickCount;
      }
    }
  };

  Capsule.prototype.move = function(direction) {
    var newX;
    switch (direction) {
      case Direction.LEFT:
        newX = (this.x - 1) | 0;
        break;
      case Direction.RIGHT:
        newX = (this.x + 1) | 0;
    }
    if ((newX != null) && !this.checkCollision(newX, this.y)) {
      this.x = newX;
      this.game.playerDidMoveCapsule(this.player);
    }
  };

  Capsule.prototype.rotate = function(direction) {
    var didRotateSuccessfully, isHorizontalToVerticalRotation, topLeftCell;
    this.flip(this.fallingBuffer, direction);
    didRotateSuccessfully = true;
    if (this.checkCollision()) {
      topLeftCell = this.fallingBuffer.get(0, 0);
      isHorizontalToVerticalRotation = !Cell.isEmpty(topLeftCell);
      if (isHorizontalToVerticalRotation) {
        if (!this.checkCollision(this.x + 1, this.y)) {
          this.x += 1;
        } else if (!this.checkCollision(this.x, this.y + 1)) {
          this.y += 1;
        } else if (!this.checkCollision(this.x + 1, this.y + 1)) {
          this.x += 1;
          this.y += 1;
        } else {
          didRotateSuccessfully = false;
        }
      } else {
        if (!this.checkCollision(this.x - 1, this.y)) {
          this.x -= 1;
        } else {
          didRotateSuccessfully = false;
        }
      }
    }
    if (didRotateSuccessfully) {
      this.game.playerDidRotateCapsule(this.player);
    } else {
      this.flip(this.fallingBuffer, Direction.reverse(direction));
    }
  };

  Capsule.prototype.swapHold = function() {
    var swapBuffer;
    swapBuffer = this.fallingBuffer;
    this.fallingBuffer = this.holdBuffer;
    this.holdBuffer = swapBuffer;
    this.x = this.startX;
    this.y = this.startY;
  };

  Capsule.prototype.writeToGrid = function() {
    this.blit(this.fallingBuffer, this.grid, this.x, this.y);
    this.fallingBuffer.clear();
  };

  Capsule.prototype.blit = function(source, dest, destOffsetX, destOffsetY) {
    var cell, destX, destY, i, j, ref, ref1, x, y;
    if (destOffsetX == null) {
      destOffsetX = 0;
    }
    if (destOffsetY == null) {
      destOffsetY = 0;
    }
    destOffsetX = destOffsetX | 0;
    destOffsetY = destOffsetY | 0;
    for (x = i = 0, ref = this.size; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
      for (y = j = 0, ref1 = this.size; 0 <= ref1 ? j < ref1 : j > ref1; y = 0 <= ref1 ? ++j : --j) {
        if (!(Cell.isEmpty(cell = source.get(x, y)))) {
          destX = destOffsetX + x;
          destY = destOffsetY + y;
          dest.set(destX, destY, cell);
          if (y !== 0 && destY === 0) {
            if (Direction.UP === Cell.getDirection(cell)) {
              dest.reshape(destX, destY);
            }
          }
        }
      }
    }
  };

  Capsule.prototype.random = function(buffer) {
    var cell, dim, direction, i, j, numColors, ref, ref1, x, y;
    if (buffer == null) {
      buffer = this.nextBuffer;
    }
    dim = (this.size - 1) | 0;
    numColors = this.player.numColors;
    for (x = i = 0, ref = this.size; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
      for (y = j = 0, ref1 = this.size; 0 <= ref1 ? j < ref1 : j > ref1; y = 0 <= ref1 ? ++j : --j) {
        if (y < dim) {
          buffer.clear(x, y);
        } else {
          cell = Cell.randomColor(numColors);
          switch (x) {
            case 0:
              direction = Direction.RIGHT;
              break;
            case dim:
              direction = Direction.LEFT;
              break;
            default:
              direction = Direction.HORIZ;
          }
          cell = Cell.setDirection(cell, direction);
          buffer.set(x, y, cell);
        }
      }
    }
  };

  Capsule.prototype.flip = function(buffer, direction) {
    var btmRight, cell, cellDirection, dim, i, j, k, l, ref, ref1, ref2, ref3, rotatedCell, rotatedDirection, topRight, x, y;
    dim = (this.size - 1) | 0;
    for (x = i = 0, ref = dim; 0 <= ref ? i <= ref : i >= ref; x = 0 <= ref ? ++i : --i) {
      for (y = j = 0, ref1 = dim; 0 <= ref1 ? j <= ref1 : j >= ref1; y = 0 <= ref1 ? ++j : --j) {
        if (direction === Direction.LEFT) {
          cell = buffer.get(dim - y, x);
        } else if (direction === Direction.RIGHT) {
          cell = buffer.get(y, dim - x);
        }
        cellDirection = Cell.getDirection(cell);
        rotatedDirection = Direction.rotate(cellDirection, direction);
        rotatedCell = Cell.setDirection(cell, rotatedDirection);
        this.rotateBuffer.set(x, y, rotatedCell);
      }
    }
    topRight = this.rotateBuffer.get(dim, 0);
    btmRight = this.rotateBuffer.get(dim, dim);
    if ((!Cell.isEmpty(topRight)) && (!Cell.isEmpty(btmRight))) {
      for (y = k = 0, ref2 = dim; 0 <= ref2 ? k <= ref2 : k >= ref2; y = 0 <= ref2 ? ++k : --k) {
        cell = this.rotateBuffer.get(dim, y);
        this.rotateBuffer.clear(dim, y);
        this.rotateBuffer.set(0, y, cell);
      }
    } else if (!Cell.isEmpty(topRight)) {
      for (x = l = 0, ref3 = dim; 0 <= ref3 ? l <= ref3 : l >= ref3; x = 0 <= ref3 ? ++l : --l) {
        cell = this.rotateBuffer.get(x, 0);
        this.rotateBuffer.clear(x, 0);
        this.rotateBuffer.set(x, dim, cell);
      }
    }
    buffer.clear();
    this.blit(this.rotateBuffer, buffer);
  };

  Capsule.prototype.checkCollision = function(originX, originY) {
    var capsuleCell, gridCell, gridX, gridY, i, j, ref, ref1, x, y;
    if (originX == null) {
      originX = this.x;
    }
    if (originY == null) {
      originY = this.y;
    }
    originX = originX | 0;
    originY = originY | 0;
    for (x = i = 0, ref = this.size; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
      for (y = j = 0, ref1 = this.size; 0 <= ref1 ? j < ref1 : j > ref1; y = 0 <= ref1 ? ++j : --j) {
        capsuleCell = this.fallingBuffer.get(x, y);
        if (Cell.isEmpty(capsuleCell)) {
          continue;
        }
        gridX = (originX + x) | 0;
        gridY = (originY + y) | 0;
        if (gridX < 0 || gridX >= this.grid.width) {
          return true;
        }
        if (gridY >= this.grid.height) {
          return true;
        }
        gridCell = this.grid.get(gridX, gridY);
        if (!Cell.isEmpty(gridCell)) {
          return true;
        }
      }
    }
    return false;
  };

  return Capsule;

})();


/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

var Capsule, Cell, Direction, Matrix, PlayerInput, PlayerState, Speed, calculateScore, clamp, defaultCapsuleSize, defaultFallingTickRate, defaultHeight, defaultLevel, defaultLevelVirusMultiplier, defaultLineLength, defaultMaxYCeiling, defaultMinYCeiling, defaultNumColors, defaultSpeed, defaultSpeedUpRate, defaultWidth, maxCombo, maxNumColors, maxSpeedCount, minCombo, minNumColors, randomInRange, scoreMultiplier;

Cell = __webpack_require__(0);

Direction = __webpack_require__(1);

Matrix = __webpack_require__(6);

Capsule = __webpack_require__(13);

PlayerInput = __webpack_require__(3);

Speed = __webpack_require__(4);

defaultWidth = 10;

defaultHeight = 16;

defaultSpeed = Speed.MED;

defaultLevel = 10;

defaultNumColors = 3;

minNumColors = 1;

maxNumColors = 7;

maxSpeedCount = 49;

defaultCapsuleSize = 2;

defaultLineLength = 4;

defaultMinYCeiling = 3;

defaultMaxYCeiling = 9;

defaultSpeedUpRate = 10;

defaultFallingTickRate = 8;

defaultLevelVirusMultiplier = 4;

minCombo = 1;

maxCombo = 6;

scoreMultiplier = 100;

calculateScore = function(speed, numViruses) {
  var baseCombo, comboIndex, i, numCombos, ref, ref1, score;
  numViruses = numViruses | 0;
  baseCombo = Speed.baseScoreCombo(speed);
  numCombos = clamp(numViruses, minCombo, maxCombo);
  score = 0;
  for (comboIndex = i = ref = minCombo, ref1 = numCombos; ref <= ref1 ? i <= ref1 : i >= ref1; comboIndex = ref <= ref1 ? ++i : --i) {
    score += (scoreMultiplier * (Math.pow(baseCombo, comboIndex))) | 0;
  }
  return score | 0;
};

randomInRange = function(start, end) {
  start = start | 0;
  end = end | 0;
  return (start + (Math.random() * (end - start))) | 0;
};

clamp = function(val, min, max) {
  val = val | 0;
  min = min | 0;
  max = max | 0;
  return (Math.min(Math.max(val, min), max)) | 0;
};

module.exports = PlayerState = (function() {
  function PlayerState(options) {
    var ref, ref1, ref10, ref11, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9;
    if (options == null) {
      options = {};
    }
    this.game = options.game;
    this.speed = (ref = Speed.fromOption(options.speed)) != null ? ref : defaultSpeed;
    this.width = (ref1 = options.width) != null ? ref1 : defaultWidth;
    this.height = (ref2 = options.height) != null ? ref2 : defaultHeight;
    this.numColors = (ref3 = options.numColors) != null ? ref3 : defaultNumColors;
    this.numColors = clamp(this.numColors, minNumColors, maxNumColors);
    this.lineLength = (ref4 = options.lineLength) != null ? ref4 : defaultLineLength;
    this.capsuleSize = (ref5 = options.capsuleSize) != null ? ref5 : defaultCapsuleSize;
    this.minYCeiling = (ref6 = options.minYCeiling) != null ? ref6 : defaultMinYCeiling;
    this.maxYCeiling = (ref7 = options.maxYCeiling) != null ? ref7 : defaultMaxYCeiling;
    this.fallingTickRate = (ref8 = options.fallingTickRate) != null ? ref8 : defaultFallingTickRate;
    this.speedUpRate = (ref9 = options.speedUpRate) != null ? ref9 : defaultSpeedUpRate;
    this.levelVirusMultiplier = (ref10 = options.levelVirusMultiplier) != null ? ref10 : defaultLevelVirusMultiplier;
    this.reset((ref11 = options.level) != null ? ref11 : defaultLevel);
  }

  PlayerState.prototype.reset = function(level) {
    var attemptsLeft, bottomRightOpenIndex, cellIndex, i, levelViruses, lineDirection, openCellIndexes, randomColor, randomOpenIndex, randomVirus, ref, results, topLeftOpenIndex, x, y, yCeiling;
    this.isGameOver = false;
    this.level = (ref = level != null ? level : this.level) != null ? ref : defaultLevel;
    this.score = 0;
    this.speedCount = 0;
    this.capsuleCount = 0;
    this.tickCount = 0;
    this.tickRate = Speed.calculateTickRate(this.speed, this.speedCount);
    this.grid = new Matrix(this);
    this.capsule = new Capsule(this);
    yCeiling = clamp(this.height - this.level, this.minYCeiling, this.maxYCeiling);
    topLeftOpenIndex = yCeiling * this.width;
    bottomRightOpenIndex = this.width + ((this.height - 1) * this.width);
    openCellIndexes = (function() {
      results = [];
      for (var i = topLeftOpenIndex; topLeftOpenIndex <= bottomRightOpenIndex ? i < bottomRightOpenIndex : i > bottomRightOpenIndex; topLeftOpenIndex <= bottomRightOpenIndex ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this);
    this.virusesLeft = 0;
    this.virusesLeftByColor = [0];
    levelViruses = (this.levelVirusMultiplier * this.level) + this.levelVirusMultiplier;
    while (this.virusesLeft < levelViruses && openCellIndexes.length) {
      randomOpenIndex = randomInRange(0, openCellIndexes.length);
      cellIndex = openCellIndexes[randomOpenIndex];
      openCellIndexes.splice(randomOpenIndex, 1);
      x = (cellIndex % this.width) | 0;
      y = (cellIndex / this.width) | 0;
      lineDirection = Direction.CROSS;
      attemptsLeft = this.numColors * 2;
      while (lineDirection && attemptsLeft) {
        randomColor = Cell.randomColor(this.numColors);
        randomVirus = Cell.setVirus(randomColor);
        this.grid.set(x, y, randomVirus);
        lineDirection = this.grid.checkLineDirections(x, y);
        attemptsLeft -= 1;
      }
      if (lineDirection) {
        this.grid.clear(x, y);
      } else {
        this.virusesLeft += 1;
        if (this.virusesLeftByColor[randomColor] != null) {
          this.virusesLeftByColor[randomColor] += 1;
        } else {
          this.virusesLeftByColor[randomColor] = 1;
        }
      }
    }
  };

  PlayerState.prototype.tick = function() {
    var cellsCleared, cellsDropped, clearResult, isPlaced, linesMarked, virusesCleared;
    this.tickCount += 1;
    if (this.isGameOver || this.tickCount % this.tickRate) {
      return false;
    } else if (0 === this.virusesLeft) {
      this.isGameOver = true;
      this.game.playerDidEndGame(this, true);
    } else if (this.capsule.isFalling()) {
      if (this.capsule.isOutOfBounds()) {
        this.isGameOver = true;
        this.game.playerDidEndGame(this, false);
        return true;
      }
      this.capsule.drop();
      isPlaced = this.tickCount !== this.capsule.landedTick || this.tickRate === 0;
      if (this.capsule.isLanded() && isPlaced) {
        this.capsule.writeToGrid();
        this.game.playerDidWriteCellsToGrid(this, this.capsule.size);
        if (this.fallingTickRate != null) {
          this.tickRate = this.fallingTickRate;
        }
        if (linesMarked = this.grid.markLines()) {
          this.recomputeVirusesLeft(linesMarked);
        }
      }
    } else if (clearResult = this.grid.clearMarked()) {
      virusesCleared = clearResult >>> 16;
      cellsCleared = clearResult & 0xFFFF;
      if (virusesCleared) {
        this.score += calculateScore(this.speed, virusesCleared);
      }
      this.game.playerDidClearMarked(this, cellsCleared, virusesCleared);
    } else if (cellsDropped = this.grid.dropFalling()) {
      this.game.playerDidWriteCellsToGrid(this, cellsDropped);
    } else if (linesMarked = this.grid.markLines()) {
      this.recomputeVirusesLeft(linesMarked);
    } else {
      this.capsule.generate();
      this.game.playerDidSpawnCapsule(this);
      this.capsuleCount += 1;
      if (0 === this.capsuleCount % this.speedUpRate && this.speedCount < maxSpeedCount) {
        this.speedCount += 1;
        this.game.playerDidSpeedUp(this);
      }
      this.tickRate = Speed.calculateTickRate(this.speed, this.speedCount);
    }
    return true;
  };

  PlayerState.prototype.recomputeVirusesLeft = function(linesMarked) {
    var colorIndex, didClearColor, i, markedColoredVirus, numMarkedColoredViruses, ref, virusesMarked;
    linesMarked = linesMarked | 0;
    virusesMarked = 0;
    didClearColor = false;
    for (colorIndex = i = 1, ref = this.numColors; 1 <= ref ? i <= ref : i >= ref; colorIndex = 1 <= ref ? ++i : --i) {
      markedColoredVirus = Cell.setVirus(Cell.setMark(colorIndex));
      if (numMarkedColoredViruses = this.grid.count(markedColoredVirus)) {
        virusesMarked += numMarkedColoredViruses;
        if (0 === (this.virusesLeftByColor[colorIndex] -= numMarkedColoredViruses)) {
          didClearColor = true;
        }
      }
    }
    if (virusesMarked) {
      this.virusesLeft -= virusesMarked;
    }
    this.game.playerDidMarkLines(this, linesMarked, virusesMarked, didClearColor);
  };

  PlayerState.prototype.applyInput = function(input) {
    if (!this.capsule.isFalling() || this.capsule.isOutOfBounds()) {
      return;
    }
    if (PlayerInput.get(input, PlayerInput.MOVE_LEFT)) {
      this.capsule.move(Direction.LEFT);
    }
    if (PlayerInput.get(input, PlayerInput.MOVE_RIGHT)) {
      this.capsule.move(Direction.RIGHT);
    }
    if (PlayerInput.get(input, PlayerInput.FLIP_LEFT)) {
      this.capsule.rotate(Direction.LEFT);
    }
    if (PlayerInput.get(input, PlayerInput.FLIP_RIGHT)) {
      this.capsule.rotate(Direction.RIGHT);
    }
    if (PlayerInput.get(input, PlayerInput.FAST_DROP)) {
      this.tickRate = 0;
    } else if (this.tickRate === 0) {
      this.tickRate = Speed.calculateTickRate(this.speed, this.speedCount);
    }
    if (PlayerInput.get(input, PlayerInput.INSTANT_DROP)) {
      while (!this.capsule.isLanded()) {
        this.capsule.drop();
      }
      this.tickRate = 0;
    }
    if (PlayerInput.get(input, PlayerInput.SWAP_HOLD)) {
      this.capsule.swapHold();
    }
  };

  return PlayerState;

})();


/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

var base64ToByteArray, dataUriPrefix, fileExt, files, loadAll, loadFile;

files = ['chill', 'defeat', 'drop', 'fever', 'flip', 'game-over', 'match-over', 'menu', 'move', 'color-clear', 'pause', 'pill-clear', 'setup', 'speed-up', 'taunt1', 'taunt2', 'victory', 'virus-clear'];

fileExt = '.mp3';

dataUriPrefix = 'data:audio/mpeg;base64,';

base64ToByteArray = function(base64) {
  var data, i, j, ref, result, size;
  data = atob(base64);
  size = data.length;
  result = new Uint8Array(size);
  for (i = j = 0, ref = size; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
    result[i] = data.charCodeAt(i);
  }
  return result;
};

loadFile = function(file, done) {
  var request;
  request = new XMLHttpRequest();
  request.open('GET', file, true);
  request.responseType = 'arraybuffer';
  request.addEventListener('load', function() {
    return done(request.response);
  });
  request.send();
};

loadAll = function(done) {
  var data, file, j, len, maybeDone, maybeDoneAfterLoad, name, numLoaded, result;
  result = {};
  numLoaded = 0;
  maybeDone = function() {
    if (numLoaded === files.length) {
      done(result);
    }
  };
  maybeDoneAfterLoad = function(name) {
    return function(response) {
      result[name] = response;
      numLoaded += 1;
      maybeDone();
    };
  };
  for (j = 0, len = files.length; j < len; j++) {
    name = files[j];
    file = __webpack_require__(43)("./" + name + fileExt);
    if (file.slice(-fileExt.length) === fileExt) {
      loadFile(file, maybeDoneAfterLoad(name));
    } else if (file.slice(0, dataUriPrefix.length) === dataUriPrefix) {
      data = base64ToByteArray(file.slice(dataUriPrefix.length));
      result[name] = data.buffer;
      numLoaded += 1;
    }
  }
  maybeDone();
};

module.exports = {
  base64ToByteArray: base64ToByteArray,
  loadFile: loadFile,
  loadAll: loadAll,
  files: files
};


/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

var GameView, Player, Timer, eventCharacter,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

eventCharacter = __webpack_require__(2).eventCharacter;

Timer = __webpack_require__(5);

Player = __webpack_require__(21);

module.exports = GameView = (function() {
  GameView.prototype.events = {
    'keydown': 'handleKeyDown',
    'keyup': 'handleKeyUp'
  };

  GameView.prototype.paused = true;

  GameView.prototype.lastTick = null;

  GameView.prototype.tickRate = 1000 / 30;

  GameView.prototype.tickEpsilon = 5;

  GameView.prototype.clockType = Timer.REQUEST_FRAME;

  GameView.prototype.clockRef = null;

  function GameView(arg) {
    var options, playerName, players, ref;
    this.app = arg.app, this.music = arg.music, players = arg.players;
    this.handleEvent = bind(this.handleEvent, this);
    this.handleVisibilityChange = bind(this.handleVisibilityChange, this);
    this.loop = bind(this.loop, this);
    this.sound = this.app.sound;
    if (this.music !== 'quiet') {
      if ((ref = this.sound) != null) {
        ref.play(this.music);
      }
    }
    this.players = [];
    for (playerName in players) {
      options = players[playerName];
      options.app = this.app;
      options.game = this;
      this.players.push(new Player(options));
    }
    return;
  }

  GameView.prototype.render = function() {
    var eventType, handler, i, len, player, ref, ref1;
    this.el = document.createElement('ul');
    this.el.id = 'game';
    ref = this.players;
    for (i = 0, len = ref.length; i < len; i++) {
      player = ref[i];
      this.el.appendChild(player.render());
    }
    ref1 = this.events;
    for (eventType in ref1) {
      handler = ref1[eventType];
      window.addEventListener(eventType, this.handleEvent, false);
    }
    document.addEventListener('visibilitychange', this.handleVisibilityChange);
    return this.el;
  };

  GameView.prototype.destroy = function() {
    var eventType, handler, i, len, player, ref, ref1, ref2, ref3, ref4, ref5;
    if ((ref = this.sound) != null) {
      ref.stopLast();
    }
    if ((ref1 = this.sound) != null) {
      ref1.stopLoop();
    }
    this.pause();
    if ((ref2 = this.el) != null) {
      if ((ref3 = ref2.parentNode) != null) {
        ref3.removeChild(this.el);
      }
    }
    delete this.el;
    ref4 = this.players;
    for (i = 0, len = ref4.length; i < len; i++) {
      player = ref4[i];
      player.destroy();
    }
    delete this.players;
    ref5 = this.events;
    for (eventType in ref5) {
      handler = ref5[eventType];
      window.removeEventListener(eventType, this.handleEvent, false);
    }
    document.removeEventListener('visibilitychange', this.handleVisibilityChange);
  };

  GameView.prototype.unpause = function() {
    this.paused = false;
    if (this.lastTick == null) {
      this.lastTick = Timer.now();
    }
    this.clockRef = Timer.start(this.clockType, this.loop, this.tickRate);
  };

  GameView.prototype.pause = function() {
    var ref;
    if ((ref = this.sound) != null) {
      ref.play('pause');
    }
    this.paused = true;
    this.lastTick = null;
    if (this.clockRef != null) {
      Timer.stop(this.clockType, this.clockRef);
    }
    this.clockRef = null;
  };

  GameView.prototype.togglePaused = function() {
    if (this.paused) {
      this.unpause();
    } else {
      this.pause();
    }
  };

  GameView.prototype.reset = function() {
    var i, len, player, ref, ref1, ref2;
    if ((ref = this.sound) != null) {
      ref.stopLast();
    }
    this.pause();
    ref1 = this.players;
    for (i = 0, len = ref1.length; i < len; i++) {
      player = ref1[i];
      player.reset();
    }
    this.unpause();
    if (this.music !== 'quiet') {
      if ((ref2 = this.sound) != null) {
        ref2.play(this.music);
      }
    }
  };

  GameView.prototype.loop = function() {
    var deltaTicks, i, j, k, l, len, len1, len2, now, player, ref, ref1, ref2, ref3, tick;
    if (this.paused) {
      return;
    }
    now = Timer.now();
    deltaTicks = (now - this.lastTick) / this.tickRate | 0;
    if (deltaTicks && deltaTicks <= this.tickEpsilon) {
      ref = this.players;
      for (i = 0, len = ref.length; i < len; i++) {
        player = ref[i];
        player.handleGamepad();
      }
      for (tick = j = 0, ref1 = deltaTicks; 0 <= ref1 ? j < ref1 : j > ref1; tick = 0 <= ref1 ? ++j : --j) {
        ref2 = this.players;
        for (k = 0, len1 = ref2.length; k < len1; k++) {
          player = ref2[k];
          player.tick();
        }
      }
      ref3 = this.players;
      for (l = 0, len2 = ref3.length; l < len2; l++) {
        player = ref3[l];
        player.update();
      }
      this.lastTick = now;
    }
    if (!Timer.isRepeating(this.clockType)) {
      this.unpause();
    }
  };

  GameView.prototype.handleVisibilityChange = function(event) {
    var ref, ref1;
    if (document.hidden) {
      if (!this.paused) {
        this.pause();
      }
      if ((ref = this.sound) != null) {
        ref.stopLoop();
      }
    } else {
      if (this.music !== 'quiet') {
        if ((ref1 = this.sound) != null) {
          ref1.play(this.music);
        }
      }
    }
  };

  GameView.prototype.handleEvent = function(event) {
    var eventHandlerKey, i, isEventHandled, len, player, ref, ref1, ref2;
    if (eventHandlerKey = this.events[event.type]) {
      isEventHandled = (ref = typeof this[eventHandlerKey] === "function" ? this[eventHandlerKey](event) : void 0) != null ? ref : false;
      if (!this.paused) {
        ref1 = this.players;
        for (i = 0, len = ref1.length; i < len; i++) {
          player = ref1[i];
          if (!isEventHandled) {
            isEventHandled = (ref2 = typeof player[eventHandlerKey] === "function" ? player[eventHandlerKey](event) : void 0) != null ? ref2 : false;
          }
        }
      }
      if (isEventHandled && !event.metaKey) {
        event.preventDefault();
        return false;
      }
    }
  };

  GameView.prototype.handleKeyDown = function(event) {
    switch (eventCharacter(event)) {
      case 'p':
      case 'r':
      case 'q':
      case 'esc':
        return true;
    }
    return false;
  };

  GameView.prototype.handleKeyUp = function(event) {
    switch (eventCharacter(event)) {
      case 'p':
        this.togglePaused();
        return true;
      case 'r':
        this.reset();
        return true;
      case 'q':
      case 'esc':
        this.app.showSetup();
        return true;
    }
    return false;
  };

  GameView.prototype.playerDidSpawnCapsule = function(player) {};

  GameView.prototype.playerDidMoveCapsule = function(player) {
    var ref;
    if ((ref = this.sound) != null) {
      ref.play('move');
    }
  };

  GameView.prototype.playerDidRotateCapsule = function(player) {
    var ref;
    if ((ref = this.sound) != null) {
      ref.play('flip');
    }
  };

  GameView.prototype.playerDidWriteCellsToGrid = function(player, numCells) {
    var ref;
    if ((ref = this.sound) != null) {
      ref.play('drop');
    }
  };

  GameView.prototype.playerDidSpeedUp = function(player) {
    var ref;
    if ((ref = this.sound) != null) {
      ref.play('speed-up');
    }
  };

  GameView.prototype.playerDidMarkLines = function(player, numLines, numViruses, didClearColor) {
    var ref, ref1, ref2;
    if (didClearColor) {
      if ((ref = this.sound) != null) {
        ref.play('color-clear');
      }
    } else if (numViruses) {
      if ((ref1 = this.sound) != null) {
        ref1.play('virus-clear');
      }
    } else {
      if ((ref2 = this.sound) != null) {
        ref2.play('pill-clear');
      }
    }
    if (numLines > 1 && this.players.length > 1) {
      console.log('Marked %d lines; attacking!', numLines);
    }
  };

  GameView.prototype.playerDidClearMarked = function(player, numCells, numViruses) {};

  GameView.prototype.playerDidEndGame = function(player, isVictory) {
    var ref, ref1, ref2;
    if ((ref = this.sound) != null) {
      ref.stopLoop();
    }
    if (isVictory) {
      console.log('You win!');
      if ((ref1 = this.sound) != null) {
        ref1.play('victory');
      }
    } else {
      console.log('Game over!');
      if ((ref2 = this.sound) != null) {
        ref2.play('game-over');
      }
    }
  };

  return GameView;

})();


/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

var PlayerScoreboardView, Speed;

Speed = __webpack_require__(4);

module.exports = PlayerScoreboardView = (function() {
  PlayerScoreboardView.prototype.fields = ['score', 'virus', 'level', 'speed'];

  function PlayerScoreboardView(arg) {
    this.state = arg.state;
    return;
  }

  PlayerScoreboardView.prototype.render = function() {
    var field, i, keyElem, len, ref, valueElem;
    this.el = document.createElement('dl');
    this.el.className = 'player-scoreboard';
    ref = this.fields;
    for (i = 0, len = ref.length; i < len; i++) {
      field = ref[i];
      keyElem = document.createElement('dt');
      keyElem.innerText = field;
      this.el.appendChild(keyElem);
      valueElem = document.createElement('dd');
      this.el.appendChild(valueElem);
      this[field + 'Elem'] = valueElem;
    }
    this.levelElem.innerText = "" + this.state.level;
    this.speedElem.innerText = Speed.options[this.state.speed];
    return this.el;
  };

  PlayerScoreboardView.prototype.destroy = function() {
    var field, i, len, ref, ref1, ref2;
    ref = this.fields;
    for (i = 0, len = ref.length; i < len; i++) {
      field = ref[i];
      delete this[field + 'Elem'];
    }
    if ((ref1 = this.el) != null) {
      if ((ref2 = ref1.parentNode) != null) {
        ref2.removeChild(this.el);
      }
    }
    delete this.el;
  };

  PlayerScoreboardView.prototype.update = function() {
    this.scoreElem.innerText = "" + this.state.score;
    this.virusElem.innerText = "" + this.state.virusesLeft;
  };

  return PlayerScoreboardView;

})();


/***/ }),
/* 18 */
/***/ (function(module, exports, __webpack_require__) {

var PlayerMatrixView, PlayerStateView, Timer, setter, tickClassName, tockClassName;

setter = function(klass, prop, set) {
  return Object.defineProperty(klass.prototype, prop, {
    set: set,
    configurable: true
  });
};

Timer = __webpack_require__(5);

PlayerMatrixView = __webpack_require__(7);

tickClassName = 'player-state tick';

tockClassName = 'player-state tock';

module.exports = PlayerStateView = (function() {
  setter(PlayerStateView, 'state', function(state) {
    var ref;
    this._state = state;
    if ((ref = this.matrixView) != null) {
      ref.state = state;
    }
  });

  PlayerStateView.prototype.lastTick = null;

  PlayerStateView.prototype.tickRate = 250;

  function PlayerStateView(arg) {
    this.state = arg.state;
    this.lastTick = Timer.now();
    return;
  }

  PlayerStateView.prototype.render = function() {
    this.el = document.createElement('figure');
    this.el.className = tickClassName;
    this.matrixView = new PlayerMatrixView({
      state: this._state
    });
    this.el.appendChild(this.matrixView.render());
    this.update();
    return this.el;
  };

  PlayerStateView.prototype.destroy = function() {
    var ref, ref1, ref2;
    if ((ref = this.matrixView) != null) {
      ref.destroy();
    }
    delete this.matrixView;
    if ((ref1 = this.el) != null) {
      if ((ref2 = ref1.parentNode) != null) {
        ref2.removeChild(this.el);
      }
    }
    delete this.el;
  };

  PlayerStateView.prototype.update = function() {
    var now, ref;
    if ((ref = this.matrixView) != null) {
      ref.update();
    }
    now = Timer.now();
    if (this.lastTick + this.tickRate < now) {
      this.lastTick = now;
      if (this.el.className !== tickClassName) {
        this.el.className = tickClassName;
      } else {
        this.el.className = tockClassName;
      }
    }
  };

  return PlayerStateView;

})();


/***/ }),
/* 19 */
/***/ (function(module, exports, __webpack_require__) {

var PlayerInput, PlayerTouchControlsView, buttonActions,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

PlayerInput = __webpack_require__(3);

buttonActions = {
  'back': PlayerInput.NONE,
  'pause': PlayerInput.NONE,
  'retry': PlayerInput.NONE,
  'move-left': PlayerInput.MOVE_LEFT,
  'move-right': PlayerInput.MOVE_RIGHT,
  'fast-drop': PlayerInput.FAST_DROP,
  'flip-left': PlayerInput.FLIP_LEFT,
  'flip-right': PlayerInput.FLIP_RIGHT
};

module.exports = PlayerTouchControlsView = (function() {
  function PlayerTouchControlsView(arg) {
    this.app = arg.app, this.game = arg.game, this.player = arg.player;
    this.handleTouchEnd = bind(this.handleTouchEnd, this);
    this.handleTouchStart = bind(this.handleTouchStart, this);
    return;
  }

  PlayerTouchControlsView.prototype.render = function() {
    var action, buttonEl, name;
    this.el = document.createElement('div');
    this.el.id = 'player-touch-controls';
    for (name in buttonActions) {
      action = buttonActions[name];
      buttonEl = document.createElement('button');
      buttonEl.name = name;
      buttonEl.innerText = name.replace('-', ' ');
      this.el.appendChild(buttonEl);
    }
    this.el.addEventListener('touchstart', this.handleTouchStart);
    this.el.addEventListener('touchend', this.handleTouchEnd);
    return this.el;
  };

  PlayerTouchControlsView.prototype.destroy = function() {
    var ref, ref1;
    this.el.removeEventListener('touchstart', this.handleTouchStart);
    this.el.removeEventListener('touchend', this.handleTouchEnd);
    if ((ref = this.el) != null) {
      if ((ref1 = ref.parentNode) != null) {
        ref1.removeChild(this.el);
      }
    }
    delete this.el;
  };

  PlayerTouchControlsView.prototype.handleTouchStart = function(event) {
    var name;
    event.preventDefault();
    if (!(name = event.target.name)) {
      return;
    }
    switch (name) {
      case 'back':
        this.app.showSetup();
        break;
      case 'pause':
        this.game.togglePaused();
        break;
      case 'retry':
        this.game.reset();
        break;
      default:
        this.player.beginAction(buttonActions[name]);
    }
  };

  PlayerTouchControlsView.prototype.handleTouchEnd = function(event) {
    var name;
    if (!(name = event.target.name)) {
      return;
    }
    this.player.endAction(buttonActions[name]);
  };

  return PlayerTouchControlsView;

})();


/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

var PlayerMatrixView, PlayerUpNextView, setter;

setter = function(klass, prop, set) {
  return Object.defineProperty(klass.prototype, prop, {
    set: set,
    configurable: true
  });
};

PlayerMatrixView = __webpack_require__(7);

module.exports = PlayerUpNextView = (function() {
  setter(PlayerUpNextView, 'state', function(state) {
    var capsule, ref;
    capsule = state.capsule;
    this.nextBuffer = capsule.nextBuffer;
    if ((ref = this.matrixView) != null) {
      ref.buffer = this.nextBuffer;
    }
  });

  function PlayerUpNextView(options) {
    this.state = options.state;
    return;
  }

  PlayerUpNextView.prototype.render = function() {
    this.el = document.createElement('aside');
    this.el.className = 'player-up-next';
    this.matrixView = new PlayerMatrixView({
      buffer: this.nextBuffer
    });
    this.el.appendChild(this.matrixView.render());
    this.update();
    return this.el;
  };

  PlayerUpNextView.prototype.destroy = function() {
    var ref, ref1, ref2;
    if ((ref = this.matrixView) != null) {
      ref.destroy();
    }
    delete this.matrixView;
    if ((ref1 = this.el) != null) {
      if ((ref2 = ref1.parentNode) != null) {
        ref2.removeChild(this.el);
      }
    }
    delete this.el;
  };

  PlayerUpNextView.prototype.update = function() {
    var ref;
    if ((ref = this.matrixView) != null) {
      ref.update();
    }
  };

  return PlayerUpNextView;

})();


/***/ }),
/* 21 */
/***/ (function(module, exports, __webpack_require__) {

var PlayerInput, PlayerScoreboardView, PlayerState, PlayerStateView, PlayerTouchControlsView, PlayerUpNextView, PlayerView;

PlayerInput = __webpack_require__(3);

PlayerState = __webpack_require__(14);

PlayerScoreboardView = __webpack_require__(17);

PlayerStateView = __webpack_require__(18);

PlayerTouchControlsView = __webpack_require__(19);

PlayerUpNextView = __webpack_require__(20);

module.exports = PlayerView = (function() {
  function PlayerView(options1) {
    var ref;
    this.options = options1;
    ref = this.options, this.app = ref.app, this.game = ref.game, this.controls = ref.controls;
    this.isTouchDevice = this.app.isTouchDevice;
    this.reset();
    return;
  }

  PlayerView.prototype.reset = function() {
    var i, len, ref, view;
    this.state = new PlayerState(this.options);
    this.startMoveTick = this.lastMoveTick = null;
    this.input = this.holdInput = this.moveInput = PlayerInput.NONE;
    if (this.subviews != null) {
      ref = this.subviews;
      for (i = 0, len = ref.length; i < len; i++) {
        view = ref[i];
        view.state = this.state;
      }
    }
    this.update();
  };

  PlayerView.prototype.render = function() {
    var divEl, i, len, options, ref, view;
    this.el = document.createElement('li');
    this.el.className = 'player';
    options = {
      app: this.app,
      game: this.game,
      state: this.state,
      player: this
    };
    if (this.isTouchDevice) {
      this.touchView = new PlayerTouchControlsView(options);
      this.el.appendChild(this.touchView.render());
    }
    divEl = document.createElement('div');
    divEl.className = 'player-container';
    this.subviews = [(this.scoreboardView = new PlayerScoreboardView(options)), (this.upNextView = new PlayerUpNextView(options)), (this.stateView = new PlayerStateView(options))];
    ref = this.subviews;
    for (i = 0, len = ref.length; i < len; i++) {
      view = ref[i];
      divEl.appendChild(view.render());
    }
    this.el.appendChild(divEl);
    return this.el;
  };

  PlayerView.prototype.update = function() {
    var i, len, ref, view;
    if (this.subviews != null) {
      ref = this.subviews;
      for (i = 0, len = ref.length; i < len; i++) {
        view = ref[i];
        view.update();
      }
    }
  };

  PlayerView.prototype.destroy = function() {
    var i, len, ref, ref1, ref2, ref3, view;
    if ((ref = this.touchView) != null) {
      ref.destroy();
    }
    delete this.touchView;
    if (this.subviews != null) {
      ref1 = this.subviews;
      for (i = 0, len = ref1.length; i < len; i++) {
        view = ref1[i];
        view.destroy();
      }
    }
    delete this.scoreboardView;
    delete this.upNextView;
    delete this.stateView;
    delete this.subviews;
    if ((ref2 = this.el) != null) {
      if ((ref3 = ref2.parentNode) != null) {
        ref3.removeChild(this.el);
      }
    }
    delete this.el;
  };

  PlayerView.prototype.tick = function() {
    var currentTick, moveInput;
    if (PlayerInput.isNone(this.moveInput)) {
      this.startMoveTick = this.lastMoveTick = null;
    } else {
      currentTick = this.state.tickCount;
      if (currentTick > this.startMoveTick + 4) {
        if (currentTick > this.lastMoveTick + 1) {
          this.input = PlayerInput.set(this.input, this.moveInput);
        }
      }
    }
    this.state.applyInput(this.input);
    this.input = PlayerInput.clear(this.input, PlayerInput.PRESS_ACTIONS);
    moveInput = this.input & PlayerInput.MOVE_ACTIONS;
    if (!PlayerInput.isNone(moveInput)) {
      if (this.startMoveTick == null) {
        this.startMoveTick = this.lastMoveTick = this.state.tickCount;
      }
      this.moveInput = moveInput;
      this.input = PlayerInput.clear(this.input, PlayerInput.MOVE_ACTIONS);
    }
    this.state.tick();
  };

  PlayerView.prototype.actionFromEvent = function(event) {
    var controlInfo, controlName, eventControl, ref;
    eventControl = null;
    ref = this.controls;
    for (controlName in ref) {
      controlInfo = ref[controlName];
      if (controlInfo.type === 'keyCode') {
        if (controlInfo.keyCode === event.which) {
          eventControl = controlName;
          break;
        }
      }
    }
    if (eventControl != null) {
      return PlayerInput.actionFromString(eventControl);
    }
  };

  PlayerView.prototype.beginAction = function(action) {
    if (!PlayerInput.isNone(action)) {
      if (!PlayerInput.get(this.holdInput, action)) {
        this.input = PlayerInput.set(this.input, action);
        this.holdInput = PlayerInput.set(this.holdInput, action);
      }
      return true;
    } else {
      return false;
    }
  };

  PlayerView.prototype.endAction = function(action) {
    if (!PlayerInput.isNone(action)) {
      this.input = PlayerInput.clear(this.input, action);
      this.holdInput = PlayerInput.clear(this.holdInput, action);
      this.moveInput = PlayerInput.clear(this.moveInput, action);
      return true;
    } else {
      return false;
    }
  };

  PlayerView.prototype.handleKeyDown = function(event) {
    return this.beginAction(this.actionFromEvent(event));
  };

  PlayerView.prototype.handleKeyUp = function(event) {
    return this.endAction(this.actionFromEvent(event));
  };

  PlayerView.prototype.handleGamepad = function() {
    var allGamepads, button, controlAction, controlInfo, controlName, gamepad, ref;
    if (!this.app.isGamepadSupported) {
      return;
    }
    allGamepads = navigator.getGamepads();
    ref = this.controls;
    for (controlName in ref) {
      controlInfo = ref[controlName];
      if (controlInfo.type === 'gamepadButton') {
        controlAction = PlayerInput.actionFromString(controlName);
        gamepad = allGamepads[controlInfo.gamepadIndex];
        button = gamepad.buttons[controlInfo.buttonIndex];
        if (button.pressed || button.value > 0) {
          this.beginAction(controlAction);
        } else {
          this.endAction(controlAction);
        }
      }
    }
  };

  return PlayerView;

})();


/***/ }),
/* 22 */
/***/ (function(module, exports, __webpack_require__) {

var Defaults, SetupView, Speed, Timer, eventCharacter, gamepadButtonControl, keyCodeControl,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

eventCharacter = __webpack_require__(2).eventCharacter;

Speed = __webpack_require__(4);

Timer = __webpack_require__(5);

Defaults = __webpack_require__(11);

keyCodeControl = Defaults.keyCodeControl, gamepadButtonControl = Defaults.gamepadButtonControl;

module.exports = SetupView = (function() {
  SetupView.prototype.template = __webpack_require__(24);

  SetupView.prototype.eventCharacter = eventCharacter;

  SetupView.prototype.soundOptions = ['on', 'off'];

  SetupView.prototype.musicOptions = ['fever', 'chill', 'quiet'];

  SetupView.prototype.speedOptions = Speed.options;

  SetupView.prototype.events = {
    'submit form': 'formSubmitted',
    'change [name=sound]': 'soundChanged',
    'change [name=music]': 'musicChanged',
    'input [name=level]': 'levelChanged',
    'change [name=level]': 'levelChanged',
    'change [name=speed]': 'speedChanged',
    'click .controls button': 'bindControl'
  };

  function SetupView(arg) {
    var i, j, numPlayers, playerName, ref, ref1;
    this.app = arg.app, numPlayers = arg.numPlayers;
    this.maybeStartGame = bind(this.maybeStartGame, this);
    this.formSubmitted = bind(this.formSubmitted, this);
    this.handleGamepadBind = bind(this.handleGamepadBind, this);
    this.handleKeyBind = bind(this.handleKeyBind, this);
    this.bindControl = bind(this.bindControl, this);
    this.speedChanged = bind(this.speedChanged, this);
    this.levelChanged = bind(this.levelChanged, this);
    this.musicChanged = bind(this.musicChanged, this);
    this.soundChanged = bind(this.soundChanged, this);
    this.handleVisibilityChange = bind(this.handleVisibilityChange, this);
    ref = this.app, this.isTouchDevice = ref.isTouchDevice, this.sound = ref.sound;
    this.music = 'quiet';
    this.players = {};
    for (i = j = 1, ref1 = numPlayers; 1 <= ref1 ? j <= ref1 : j >= ref1; i = 1 <= ref1 ? ++j : --j) {
      playerName = 'P' + i;
      this.players[playerName] = Defaults.player(playerName);
    }
    return;
  }

  SetupView.prototype.render = function() {
    var buttonEl, j, len, player, playerEl, playerName, ref, ref1, ref2, ref3, ref4, ref5, soundValue;
    if ((ref = this.sound) != null) {
      ref.stopLoop();
    }
    if ((ref1 = this.sound) != null ? ref1.isEnabled : void 0) {
      if ((ref2 = this.sound) != null) {
        ref2.play('setup');
      }
    }
    this.el = document.createElement('div');
    this.el.id = 'setup';
    this.el.innerHTML = this.template(this);
    this.registerEventHandlers();
    soundValue = ((ref3 = this.sound) != null ? ref3.isEnabled : void 0) ? 'on' : 'off';
    (this.el.querySelector("[id=sound-" + soundValue + "]")).checked = true;
    (this.el.querySelector("[id=music-" + this.music + "]")).checked = true;
    ref4 = this.players;
    for (playerName in ref4) {
      player = ref4[playerName];
      playerEl = this.el.querySelector("[name=" + playerName + "]");
      (playerEl.querySelector("[name=level]")).value = player.level;
      (playerEl.querySelector("[id=speed-" + player.speed + "]")).checked = true;
      ref5 = playerEl.querySelectorAll('.controls button');
      for (j = 0, len = ref5.length; j < len; j++) {
        buttonEl = ref5[j];
        this.updateButtonFromControl(buttonEl);
      }
    }
    return this.el;
  };

  SetupView.prototype.destroy = function() {
    var ref, ref1;
    if ((ref = this.sound) != null) {
      ref.stopLoop();
    }
    if (this.el != null) {
      this.unregisterEventHandlers();
      if (this.bindButtonEl != null) {
        this.cleanupBindControl();
      }
      if ((ref1 = this.el.parentNode) != null) {
        ref1.removeChild(this.el);
      }
      delete this.el;
    }
  };

  SetupView.prototype.registerEventHandlers = function() {
    var callbackName, eventEl, eventSelector, eventSplit, eventStr, eventType, j, len, ref, ref1;
    ref = this.events;
    for (eventStr in ref) {
      callbackName = ref[eventStr];
      eventSplit = eventStr.indexOf(' ');
      eventType = eventStr.slice(0, eventSplit);
      eventSelector = eventStr.slice(eventSplit + 1);
      ref1 = this.el.querySelectorAll(eventSelector);
      for (j = 0, len = ref1.length; j < len; j++) {
        eventEl = ref1[j];
        eventEl.addEventListener(eventType, this[callbackName]);
      }
    }
    document.addEventListener('visibilitychange', this.handleVisibilityChange);
  };

  SetupView.prototype.unregisterEventHandlers = function() {
    var callbackName, eventEl, eventSelector, eventSplit, eventStr, eventType, j, len, ref, ref1;
    ref = this.events;
    for (eventStr in ref) {
      callbackName = ref[eventStr];
      eventSplit = eventStr.indexOf(' ');
      eventType = eventStr.slice(0, +eventSplit + 1 || 9e9);
      eventSelector = eventStr.slice(eventSplit + 1);
      ref1 = this.el.querySelectorAll(eventSelector);
      for (j = 0, len = ref1.length; j < len; j++) {
        eventEl = ref1[j];
        eventEl.removeEventListener(eventType, this[callbackName]);
      }
    }
    document.removeEventListener('visibilitychange', this.handleVisibilityChange);
  };

  SetupView.prototype.handleVisibilityChange = function(event) {
    var ref, ref1, ref2;
    if (document.hidden) {
      if ((ref = this.sound) != null) {
        ref.stopLoop();
      }
    } else {
      if ((ref1 = this.sound) != null ? ref1.isEnabled : void 0) {
        if ((ref2 = this.sound) != null) {
          ref2.play('setup');
        }
      }
    }
  };

  SetupView.prototype.soundChanged = function(event) {
    var radioEl, ref, ref1, ref2, ref3;
    if ((radioEl = event.target).checked) {
      switch (radioEl.value) {
        case 'off':
          if ((ref = this.sound) != null) {
            ref.isEnabled = false;
          }
          this.sound.stopLoop();
          break;
        case 'on':
          if ((ref1 = this.sound) != null) {
            ref1.isEnabled = true;
          }
          if ((ref2 = this.sound) != null) {
            ref2.play('move');
          }
          if ((ref3 = this.sound) != null) {
            ref3.play('setup');
          }
      }
    }
  };

  SetupView.prototype.musicChanged = function(event) {
    var radioEl, ref;
    if ((radioEl = event.target).checked) {
      this.music = radioEl.value;
      if ((ref = this.sound) != null) {
        ref.play('move');
      }
    }
  };

  SetupView.prototype.levelChanged = function(event) {
    var player, rangeEl, rangeVal, ref;
    rangeEl = event.target;
    rangeVal = rangeEl.value | 0;
    rangeEl.setAttribute('value', rangeVal);
    player = this.players[rangeEl.form.name];
    if (player.level !== rangeVal) {
      player.level = rangeVal;
      if ((ref = this.sound) != null) {
        ref.play('move');
      }
    }
  };

  SetupView.prototype.speedChanged = function(event) {
    var player, radioEl, ref;
    if ((radioEl = event.target).checked) {
      player = this.players[radioEl.form.name];
      player.speed = radioEl.value;
      if ((ref = this.sound) != null) {
        ref.play('move');
      }
    }
  };

  SetupView.prototype.bindControl = function(event) {
    var buttonEl;
    buttonEl = event.target;
    buttonEl.className = 'bind';
    buttonEl.innerText = 'bind';
    if (this.bindButtonEl != null) {
      this.unbindControl(this.bindButtonEl);
    } else {
      window.addEventListener('keydown', this.handleKeyBind, false);
      this.startGamepadBindTimer();
    }
    this.bindButtonEl = buttonEl;
  };

  SetupView.prototype.cleanupBindControl = function() {
    window.removeEventListener('keydown', this.handleKeyBind, false);
    if (this.bindControllerTimerRef != null) {
      Timer.stop(Timer.REQUEST_FRAME, this.bindControllerTimerRef);
      delete this.bindControllerTimerRef;
    }
    this.unbindControl(this.bindButtonEl);
    delete this.bindButtonEl;
  };

  SetupView.prototype.unbindControl = function(buttonEl) {
    buttonEl.className = '';
    this.updateButtonFromControl(buttonEl);
  };

  SetupView.prototype.updateButtonFromControl = function(buttonEl) {
    var controlInfo, player;
    player = this.players[buttonEl.form.name];
    controlInfo = player.controls[buttonEl.name];
    buttonEl.innerText = (function() {
      switch (controlInfo.type) {
        case 'keyCode':
          return eventCharacter(controlInfo.keyCode);
        case 'gamepadButton':
          return "P" + (controlInfo.gamepadIndex + 1) + " B" + controlInfo.buttonIndex;
        default:
          return "unbound";
      }
    })();
  };

  SetupView.prototype.handleKeyBind = function(event) {
    var boundControl, buttonEl, keyCode, player, ref;
    if ((buttonEl = this.bindButtonEl) == null) {
      return;
    }
    keyCode = (ref = event.keyCode) != null ? ref : event.which;
    if ('esc' !== eventCharacter(keyCode)) {
      player = this.players[buttonEl.form.name];
      boundControl = keyCodeControl(keyCode);
      player.controls[buttonEl.name] = boundControl;
    }
    this.cleanupBindControl();
  };

  SetupView.prototype.startGamepadBindTimer = function() {
    var timerRate, timerType;
    if (this.app.isGamepadSupported) {
      timerType = Timer.REQUEST_FRAME;
      timerRate = 1000 / 30;
      this.bindGamepadRef = Timer.start(timerType, this.handleGamepadBind, timerRate);
    }
  };

  SetupView.prototype.handleGamepadBind = function() {
    var bindButtonIndex, bindGamepadIndex, boundControl, button, buttonEl, buttonIndex, gamepad, j, k, len, len1, player, ref, ref1;
    if ((buttonEl = this.bindButtonEl) == null) {
      return;
    }
    bindGamepadIndex = null;
    bindButtonIndex = null;
    ref = navigator.getGamepads();
    for (j = 0, len = ref.length; j < len; j++) {
      gamepad = ref[j];
      if (!(gamepad != null ? gamepad.connected : void 0)) {
        continue;
      }
      if ((bindGamepadIndex != null) && (bindButtonIndex != null)) {
        break;
      }
      ref1 = gamepad.buttons;
      for (buttonIndex = k = 0, len1 = ref1.length; k < len1; buttonIndex = ++k) {
        button = ref1[buttonIndex];
        if (button.pressed || button.value > 0) {
          bindGamepadIndex = gamepad.index;
          bindButtonIndex = buttonIndex;
          break;
        }
      }
    }
    if ((bindGamepadIndex != null) && (bindButtonIndex != null)) {
      player = this.players[buttonEl.form.name];
      boundControl = gamepadButtonControl(bindGamepadIndex, bindButtonIndex);
      player.controls[buttonEl.name] = boundControl;
      this.cleanupBindControl();
    } else {
      this.startGamepadBindTimer();
    }
  };

  SetupView.prototype.formSubmitted = function(event) {
    var formEl, player, submitEl;
    formEl = event.target;
    player = this.players[formEl.name];
    if (!(player != null ? player.isReady : void 0)) {
      player.isReady = true;
      submitEl = formEl.querySelector('button[type=submit]');
      submitEl.disabled = true;
      submitEl.innerText = 'Ready!';
      if (this.startRef == null) {
        this.startRef = setTimeout(this.maybeStartGame);
      }
    }
    event.preventDefault();
    return false;
  };

  SetupView.prototype.maybeStartGame = function() {
    var isReady, player, playerName, ref;
    delete this.startRef;
    isReady = true;
    ref = this.players;
    for (playerName in ref) {
      player = ref[playerName];
      isReady = isReady && player.isReady;
    }
    if (isReady) {
      this.app.startGame({
        music: this.music,
        players: this.players
      });
    }
  };

  return SetupView;

})();


/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

var AudioContext, Sound, musicLoopOffsets, ref;

AudioContext = (ref = window.AudioContext) != null ? ref : window.webkitAudioContext;

musicLoopOffsets = {
  'menu': 0,
  'setup': 0,
  'fever': 3.189,
  'chill': 7.421
};

module.exports = Sound = (function() {
  function Sound() {
    this.isEnabled = false;
    if (AudioContext != null) {
      this.audioCtx = new AudioContext;
    }
    this.buffers = {};
    this.unloadedBuffers = 0;
    this.loadedBuffers = 0;
    this.lastSource = null;
    this.loopSource = null;
    return;
  }

  Sound.prototype.play = function(file) {
    var source;
    if (!((this.audioCtx != null) && this.isEnabled && (this.buffers[file] != null))) {
      return;
    }
    source = this.audioCtx.createBufferSource();
    source.buffer = this.buffers[file];
    source.connect(this.audioCtx.destination);
    if (source.start == null) {
      source.start = source.noteOn;
    }
    if (source.stop == null) {
      source.stop = source.noteOff;
    }
    if (musicLoopOffsets[file] != null) {
      this.stopLoop();
      this.loopSource = source;
      source.loop = true;
      source.loopStart = musicLoopOffsets[file];
    } else {
      this.lastSource = source;
    }
    source.start(0);
  };

  Sound.prototype.stopLast = function() {
    if (this.lastSource != null) {
      this.lastSource.stop(0);
      this.lastSource = null;
    }
  };

  Sound.prototype.stopLoop = function() {
    if (this.loopSource != null) {
      this.loopSource.stop(0);
      this.loopSource = null;
    }
  };

  Sound.prototype.loadAll = function(done) {
    var bufferDidLoad;
    if (done != null) {
      bufferDidLoad = (function(_this) {
        return function() {
          if (0 === _this.unloadedBuffers) {
            return done();
          }
        };
      })(this);
    }
    (__webpack_require__(15)).loadAll((function(_this) {
      return function(sounds) {
        var data, file;
        for (file in sounds) {
          data = sounds[file];
          _this.decodeAudioData(file, data, bufferDidLoad);
        }
      };
    })(this));
  };

  Sound.prototype.decodeAudioData = function(file, data, done) {
    var onFailure, onSuccess;
    this.buffers[file] = null;
    this.unloadedBuffers += 1;
    onSuccess = (function(_this) {
      return function(buffer) {
        _this.buffers[file] = buffer;
        _this.unloadedBuffers -= 1;
        _this.loadedBuffers += 1;
        if (typeof done === "function") {
          done(file);
        }
      };
    })(this);
    onFailure = (function(_this) {
      return function() {
        _this.unloadedBuffers -= 1;
        if (typeof done === "function") {
          done(file);
        }
      };
    })(this);
    this.audioCtx.decodeAudioData(data, onSuccess, onFailure);
  };

  return Sound;

})();


/***/ }),
/* 24 */
/***/ (function(module, exports) {

module.exports =(function() {
  return function(context) {
    return (function() {
      var $c, $e, $o, controlName, i, j, k, keyCode, len, len1, len2, option, player, playerName, ref, ref1, ref2, ref3, ref4;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/\//g, '&#47;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<div class='center'>");
      if (this.sound) {
        $o.push("  <div class='global'>\n    <form name='global'>\n      <h2>Sounds</h2>");
        ref = this.soundOptions;
        for (i = 0, len = ref.length; i < len; i++) {
          option = ref[i];
          $o.push("      <input id='sound-" + option + "' type='radio' name='sound' value='" + ($e($c(option))) + "'>\n      <label for='sound-" + ($e($c(option))) + "'></label>");
        }
        $o.push("      <h2>Music Type</h2>");
        ref1 = this.musicOptions;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          option = ref1[j];
          $o.push("      <input id='music-" + option + "' type='radio' name='music' value='" + ($e($c(option))) + "'>\n      <label for='music-" + ($e($c(option))) + "'></label>");
        }
        $o.push("    </form>\n  </div>");
      }
      $o.push("  <ul class='players'>");
      ref2 = this.players;
      for (playerName in ref2) {
        player = ref2[playerName];
        $o.push("    <li class='player'>\n      <form name='" + ($e($c(playerName))) + "'>\n        <h2>Level</h2>\n        <input type='range' name='level' min='0' max='20' value='10'>\n        <h2>Speed</h2>");
        ref3 = this.speedOptions;
        for (k = 0, len2 = ref3.length; k < len2; k++) {
          option = ref3[k];
          $o.push("        <input id='speed-" + option + "' type='radio' name='speed' value='" + ($e($c(option))) + "'>\n        <label for='speed-" + ($e($c(option))) + "'></label>");
        }
        if (!this.isTouchDevice) {
          $o.push("        <h2>Controls</h2>\n        <div class='controls'>");
          ref4 = player.controls;
          for (controlName in ref4) {
            keyCode = ref4[controlName];
            $o.push("          <button type='button' name='" + ($e($c(controlName))) + "'></button>");
          }
          $o.push("        </div>");
        }
        $o.push("        <button type='submit'>Ready?</button>\n      </form>\n    </li>");
      }
      $o.push("  </ul>\n</div>");
      return $o.join("\n").replace(/\s([\w-]+)='true'/mg, ' $1').replace(/\s([\w-]+)='false'/mg, '').replace(/\s(?:id|class)=(['"])(\1)/mg, "");
    }).call(context);
  };

}).call(this);


/***/ }),
/* 25 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/chill.mp3";

/***/ }),
/* 26 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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"

/***/ }),
/* 27 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/defeat.mp3";

/***/ }),
/* 28 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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"

/***/ }),
/* 29 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/fever.mp3";

/***/ }),
/* 30 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,SUQzAwAAAAAAOlRTU0UAAAAwAAAATEFNRSAzMmJpdHMgdmVyc2lvbiAzLjk5LjUgKGh0dHA6Ly9sYW1lLnNmLm5ldCn/84DEAAAAAAAAAAAAWGluZwAAAA8AAAAKAAAHvAAtLS0tLS0tLS0tUlJSUlJSUlJSUnBwcHBwcHBwcHB0dHR0dHR0dHR0mpqampqampqamsDAwMDAwMDAwMDa2tra2tra2tra8PDw8PDw8PDw8Pz8/Pz8/Pz8/Pz///////////8AAAAeTEFNRTMuOTlyBG4AAAAAAAAAADUIJAQOQQABrgAAB7xJAcX6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//OgxAAPWALJH0AAAPhru9n5tufUCAIAmD4PnygPnwICAJg+D4Pg+CAIAg7gg7BAEAG//EEMQQd/8oc4If/8Hz///E4Pwff//4Pqei0HIAooJBUBLikjjaOe+AyJMtPHnGfrSi8F9p1bgSeBgg4auUBVuAqqC6oc4Fz2CMEauMaLhH1zdk0S6QEmurqFnAAgxNxssjwSVgokKrjlgiAgNOVSaIsMsQ0XKK1Ge//rJ4CocLik6XTIvGSzYDGIAvmXm8UgBl1ABTI3Q9FBFgRCBCEipdSS0tZMAZ0sFhyf+gQ8DFKwGgrfkCIaGXQMYWEEyKstEumReIETIXpAYLZYAqPFsf+kTIKJKiPAScE/N/OiKARDjlKMkUS6kkkiSgDAcsE8XkUWzEdbf1ChwLCjh7+ef+oU0R4mev/zkMTuO3P6kl+aoACGmJUkBEZhwBj4OCwNAgHUmG+XGwYgZCzxqRngQkXL8ti58Bhdi+5gCf+C+hlBSgxonUneAGMVsG2ENFyjm8QTLZOCUyiLlFakb5uGOFpNMXKRhkbI/IaKDGTJ0VuOMXAZJkBMjYxKX9AJpICOeT6JNk+eIsWTI3JkyPmJl/yBjjJEQnANcLKJyRQuSYJw2MTJMurUXqRepf/2UTAZFGwzlxCghMDQQSSWomlJJVJVJXMf//PqQdTJ2TTHnemS8JUMMIIIEgeHQ3wILeKH/Eiyfux/8+T/1OLOf3b/9QA///Nqf+tgFjfEDgqoeKrCQAOXfTFzoDHRg//zgMT4L+tOqv+amAAByWTHRFRxxIjsubujQ1kWKtkJPsqloGn1WBlcNAY2BQGFwIR5GAMCQiLg2OBY2KEHKJIgPBs8FrIAwLAXAetfTAgIAMcB4CSrBEGADgGYA1AAb3jKAYLAoAxGLsdY1CdGiNMUAKciiZJLUZfwSBYGJQmAMZA5cUAOUQEex7GXBYeABAUrGtIxROA1AAq3+QQgYxodEAEFALBMXITZFSeJwuE3rMQMChsMYHktSn6QNggWf/OF4lhmx2F9RseN1nETUWf/8xDE+whY9oWJhRAAjv1hl4nv+iHg1BiUmf/zkMTmQTv2ol+bqQD/lgVuicY8mgpFM3E2CPCeNU3QWi6C/+WC//2/7jfVfXbIAXNUS2CEc10sjyGAgYO0g7IlDVpZAwMIgFAjtGUhkAiYnkRA+hKo1l6PLPi9AEyA0RxjrC6kVsMQ+iLGTDAY1EBgxYGOBGBqTWyAgiHxCsppJsofwF3IDQAiJPkNDGqY5pHF0c8XGTDDJkwVC0bmhFCOHseRlSUIGTyC0nUiajkgZVeDeQkSuT5wqFQhorVZdMGNjExW6rvVTqRAsPFqbsgsmCfIsK6HykyigiZHVnq10EP/E/GX/MxcR8mhnRHpAUE1s6S1JDpFk//+r/lMnkP8uoJpIv/zkMTZOKOivx+coQWlOyzEipiqVEFVCARQZUs0AYE+QCuEgIABMOStdtvf8QklyZa/zYrgJXpxEQzHDwG2gUBgcBBesFiKqBIwmzDNCEo5H5ASOIuLO/xIwMKBwFicLjGiQwAkCAiGSdgHhcXRq5MmhsZHy6d//yChy5SIiZMkdSMwQAESVvmQCwIE7pfRUiZEPIip0rL9QlhL/+sQjJz+6khZB912VUtIjST5Nof+VOYP/1LMkf6zAzRb9X/z//iZA4ESTvAAoAd9Atl/VA8NABt/xkw+SEFIS0K0BLABzEiTAHKx3MBtSwWUDs/QUh/ppplwpgkXBxA1kDBYAAwxVGUAcf/zcMTuKrOipv+aqQCC4XG//9k00y4YBtwj786EQIqDfJgLIBolxun4oAv//FjLH/QQFtKqH/KLf9ZJcmkv+sqaBFT3/QMf/We///qNfu8Rqvh+KBwOBQIBQGBgAABnE4DQEmjfE+EFMEs1C+XgO0AGoKz+OIS4e36KKH/QDlGJdLv/pGySKLf/9Q4loo3V///6iSnf//LfLf//8tVMQU1FMy45OS41VVVVVVVVVVVVVVVVVVVV//NgxOwhi6KifZOgAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MwxPQS2dKmXZRoAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MQxOkAAANIAcAAAFVVVVVVVVVVVVVVVVU="

/***/ }),
/* 31 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/game-over.mp3";

/***/ }),
/* 32 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/match-over.mp3";

/***/ }),
/* 33 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/menu.mp3";

/***/ }),
/* 34 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,SUQzAwAAAAAAOlRTU0UAAAAwAAAATEFNRSAzMmJpdHMgdmVyc2lvbiAzLjk5LjUgKGh0dHA6Ly9sYW1lLnNmLm5ldCn/84DEAAAAAAAAAAAAWGluZwAAAA8AAAAEAAADqgBtbW1tbW1tbW1tbW1tbW1tbW1tbW1tbW3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t7e3t9vb29vb29vb29vb29vb29vb29vb29vb29v////////////////////////////////8AAAAeTEFNRTMuOTlyBG4AAAAAAAAAADUIJAQUQQABrgAAA6pa67daAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//OgxAAQ4HbSX0EYAAATGALdFeuuNyAAAADGMY48Yxj4xgCDQfB/RggCAIAgCYPg+f/wQDAPn4IGfLh//4DB8H3+fKBj///8QHPB////lHaVAJArAcAYAAoNAgEA0nBh87wGbG0GByA+W83SUgChUEDkBkxJwH4VBGDDGLKGJApZIXIYgwFmDgWKB95QuCx4R6uspMuyUwgAjB4ONBPUMMQkCMojDpfVAKiq8RgMAmBQGHAcDAh9otlNO9Ty6GmtF2GSN8oAtR/nKiL+v6+rkuTKp54WZJFpFrXR8cSBHGy3jWjUNRFB4zKSQIFljQNq5EpSxsysIAYAWISx23LftiDuvFVpaXLLL4Zhmapu5Uz7Qy5KmJCDhZKORFIvUsO21t+2WP5SEgeCgVppVVjMZy7jWhprUecoqv/zsMToVwvexv+a4kEEQxQdLusqXU43JhpTosNUxbszqjHhOLABpblooKkZY0+gljW13uOwR2JZL61NTflTVaWl13/yy7AQhBAcTmXQ9jjrGlpcrWX/x+Yy7MNtLMCiEmIzW4vOQ3L3Ich+Hfl/bsbeJljkOp919atLS5BX9BYR0qrTCCCBCAR5J8YJdwJpbrXyVUxBTUUzLjk5LjVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//MQxOsEGCJ5YZEAAFVVVVVVVVVVVVVVVVX/8xDE5wAAA0gBwAAAVVVVVVVVVVVVVVVVVQ=="

/***/ }),
/* 35 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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"

/***/ }),
/* 36 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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"

/***/ }),
/* 37 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/setup.mp3";

/***/ }),
/* 38 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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"

/***/ }),
/* 39 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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"

/***/ }),
/* 40 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,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UepVpLqYE5Zf1Snfc//zEMTsAWAWZKHGAAHXMP////MTFgzMMgcU//MQxPIAAAP8AUAAAIFCgwKBQ4WmFwyRAMz/87DE/2G8FpsfnuAgwmMyiI2BK6SsKpIMXjNAYyJXStyq4ODJi4LgpZPvSx7//////////3/WYFwGEA8tYySNto6brwHIncgZyKK1NOmKgR961NWtVfx5jhTf/////////////tckFR/liQh3JLF0E6ObWEa1oMkYYwkt+PARYeB9Wl3NQvZf32ipPxGrZra7FWhXOIWqkyDAhwMplyaXH5Vax7j//j+u67VaSXVEzO9f260f+rRPEwFdCRFKi3//UXhlDLEoHkXTA3P//////yoT0WyS///qIgW0hJf//rJo7jf//////+UJBR///RIA+kJ///1Hyt66ACAMAHg0VqOi+BAAAZTFFS3Z1/1oVJkMFRAzbUQw+3//50AxYFD5PIuiL9v/+3//+sRIAkQp2db/9B8M+AE0W7//+kHsBboQOdN///////SDpyHhpqv//rHwKBDhjC///nBhimjtPTnv//kBwRQsUw8nM//zUMTYGSP2tvnYaAAyUGlxqykY4PmssJmIka4xGogRrj0NVJsMSCtc2SqMQAAqLhBfE3bZ3IqkNXbeFHKL1PlSVY3Wd+SM4VlUzU3k9iqIAFllkBc4PFF7PZJtFdzJeyCASFDCDJPhJeHhJeE33036/IDgUqbi4p7EA8Wr/csXZIr/81DE6Bn8BpG4BSSc/++SgEU/Ew+KN/+oeGBqv///IHBT//8gcKK//+7IICwiT///caOV2ahwAMAA4BAxfYvUIDrFfRYzvpito1mEMOkbKXlz7S5y0Bln2aleXlePRLkqYpGgkA+gCknMUzUydGlR/cEeMmVRZJbKZX/l5MuoF5NJ//NwxPUpk/q+8NoLVDLqBk6KCWYDhIP+u/6xwi1b//5WS42t//ZX///lRgn//9RIj+yv//K1FP7o0f/1qNjE6eSVAsCA4//0CMKBODHicwN+uDFA7EFvTTf3RRKiMH4E9BPBOC4ymt/qZMO4/AmCcYGjf////PpuYMLgAxkZv/+svgdgK5p//6YujDiigh/////9ZJDCCmn//03CyCojzWv/+pAeBIjMAAmmihNgWNgAA5M1Cq3/81DE9yCT/rr+wlrIYHf8MRE7iwOcgP4/b5mx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"

/***/ }),
/* 41 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__.p + "sounds/victory.mp3";

/***/ }),
/* 42 */
/***/ (function(module, exports) {

module.exports = "data:audio/mpeg;base64,SUQzAwAAAAAAOlRTU0UAAAAwAAAATEFNRSAzMmJpdHMgdmVyc2lvbiAzLjk5LjUgKGh0dHA6Ly9sYW1lLnNmLm5ldCn/84DEAAAAAAAAAAAAWGluZwAAAA8AAAATAAANUQAYGBgYGDo6Ojo6SEhISEhPT09PT09ZWVlZWWVlZWVlcnJycnJ8fHx8fHyFhYWFhY+Pj4+PmpqampqkpKSkpKSurq6urrm5ubm5x8fHx8fY2NjY2Njt7e3t7f39/f39//////8AAAAeTEFNRTMuOTlyBG4AAAAAAAAAADUIJALGQQABrgAADVGB+GhHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//OgxAAOKALUf0AAAJSa27HZefUCAIAmHxACDgfB8P9YPvJwfB8HAQ8QAg7+Jz5cPn/5QEHf+D/+UBB3/lz////B//1g+loAMGQEgCQHgJRYNRaLQlzA5AuMA0AAZAHMAYBowBACTAnCMpBAA47pgJgXGRWEWauvZIcBiYAAAI0Dw65p2DrmDyDM+zlNa3zwMAW1wWAFlLARgAKuwgwHAEzAgApMNEHA3OQISYA9luGJgCADz+HQCJAYGYBUpSJxf0kAOXa7vzowBI8lsUAmMHQDkxLTIDIGAoDgo5qNRqZh0RAFKFf//ThcAeBJYyyPCgCRCKWYbJFhg/gHWpVVjLgjoAiCF+bm///UWKwCb/mAIAEupYdMkwKAEjEWKIMW0EIEgLqaZd3USUSil1NjSyl9k2//WKP7/f/zwMTzbpwWvx+e8BCP/+nDFgBnOSuGACDBIBoMp4F8wPgZRoB2A1TQWYG4BxgHjchA438/HK01RM6XVt449Tvl3c//5Qo4xbn/+pSo1bAQMK/37f0QgEmBKDcYEYvpgtAAggAVpK6IeLZmE+JKYlAGJgDAFf+/7ch7L//9wba3//+v//+CM+f//hFM///3WMBcBkSCVMFoDUwOwYTGnMJOeMx4yaxgA4F5CcYCICpgEAUmJkFSZcT+RmLCtmLuGYYLwA5guCMmBMC4YXAehjYBNlZbVVMwWKkjo+/2y6tq59Z1bpyYCKJS8KR6NwJFcdRyVmKQ+Kvc01DhUJRrROJIjFxqpEe/qaxQQguCUeY5TTnNulrjo1I84HoTDrHHnKyObOPGwlElY7QRg4krI5qMmhym/ohY7/Scc/9VJsn845//MMf803/9DCDviX+XBx50l/KAmkSq2oF+R+ajk18PsPWXHcUvOz6uLb0mOgfBfE9FL/To8Qts6KlnIqAxP///oK9gAZ2//oX///zl//9T+xv///Yrf//9y+4QR/Ks///zcMTMIJs+7x/MOADAtbWA8wE5FPZ9EUiVL3u4dh+faUeQi/XKIBoYHY3cAAIxuNwKbjcAEMa/1uQMC8wxwWT////qeYYZU95j0af/V6v1mACSdDz5hlT8/MMMb///6n9p58wyeYxGCoIQf0Eyjmf4MAgqhkAAoCchu93zUaZFve23yCo1Pn05j50KZEt7vp6YIZC067mOZ4d076rt1EsCJ1v//+pf/9taxRAEw8d+797/YyuW//MwxPISm1L2XjIEzFcve8UwQjVvEdS6KHY8hOfrlwfADhCsfKwLSbc1X3z8yWGB/x//FQkv8R8YwNCx133crUQ0FWKoc8/AKAlD01a6//NQxOgZC1LeXkBVEK/ks0fkn1wASBGnRf6AnWQOCg5TyI0ku7EYzerQ1jyVS7PCmpu00NW7sZqtUMkgbZFBAUKWRBwLis+Zmzqkt4qlszas3f+KAr/pJpF4vF4iwNiRHxeNlqf1JN///X0n6SVZqXZmRUOJC3o6ias1a0WMSKt////zYMT4I6ve2v5aB+z/RRa3bSSTF0O01pJa6zEuootUijSSSrRSeiijSMi6XUDaiiijooomJqLQapBXk3bV3oFxqeAnc0sT7io9OoWH/3LgULINi6cHhaEketpGAkDIsgOBRR+U75UoAPEMb7HKjsajm//IG9UEUXb0VnVL7mnCWNjiNjjUc05HY5THNRH7IVIjoqiJMdv//5ATFv/zYMT4JlOuyn7I4Q07//2RbmlBXB4enmO3///PIyZn///nKPUMKEqy+ADrnho1sEbAbAaGVQSht19+icG6um+dGOjOllcgTAguT2/dP+hBAOi4CGFBcwocxDlcn/1Q3/50DjHf+YOlf///6o/U5///1MHWHJ/qcIBYz/+WBX4IJrEQAFFD4mkZFW/bxF3duTAae8vG8CTrljGVX//zUMTtHmu60l5hlOXbIqOumPive972f//6Z4dK0F8nDQ0Kw9k83Nz7K6qc9u63X8jZwHCg8b///k///Ex4qZLfIT////qc86KUv////nt5znOouODxjb8Hw/Wu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"

/***/ }),
/* 43 */
/***/ (function(module, exports, __webpack_require__) {

var map = {
	"./chill.mp3": 25,
	"./color-clear.mp3": 26,
	"./defeat.mp3": 27,
	"./drop.mp3": 28,
	"./fever.mp3": 29,
	"./flip.mp3": 30,
	"./game-over.mp3": 31,
	"./match-over.mp3": 32,
	"./menu.mp3": 33,
	"./move.mp3": 34,
	"./pause.mp3": 35,
	"./pill-clear.mp3": 36,
	"./setup.mp3": 37,
	"./speed-up.mp3": 38,
	"./taunt1.mp3": 39,
	"./taunt2.mp3": 40,
	"./victory.mp3": 41,
	"./virus-clear.mp3": 42
};
function webpackContext(req) {
	return __webpack_require__(webpackContextResolve(req));
};
function webpackContextResolve(req) {
	var id = map[req];
	if(!(id + 1)) // check for number or string
		throw new Error("Cannot find module '" + req + "'.");
	return id;
};
webpackContext.keys = function webpackContextKeys() {
	return Object.keys(map);
};
webpackContext.resolve = webpackContextResolve;
module.exports = webpackContext;
webpackContext.id = 43;

/***/ })
/******/ ]);