requestAnimationFrame =
  window.requestAnimationFrame       ?
  window.webkitRequestAnimationFrame ?
  window.mozRequestAnimationFrame    ?
  window.oRequestAnimationFrame      ?
  window.msRequestAnimationFrame     ?
  null

cancelAnimationFrame =
  window.cancelAnimationFrame       ?
  window.webkitCancelAnimationFrame ?
  window.mozCancelAnimationFrame    ?
  window.oCancelAnimationFrame      ?
  window.msCancelAnimationFrame     ?
  null

exports.TIMEOUT       = TIMEOUT       = 0
exports.INTERVAL      = INTERVAL      = 1
exports.REQUEST_FRAME = REQUEST_FRAME = 2

exports.isRepeating = (method) ->
  switch method
    when TIMEOUT        then false
    when INTERVAL       then true
    when REQUEST_FRAME  then false

exports.start = (method, callback, interval) ->
  switch method
    when TIMEOUT        then setTimeout callback, interval
    when INTERVAL       then setInterval callback, interval
    when REQUEST_FRAME  then requestAnimationFrame callback

exports.stop = (method, ref) ->
  switch method
    when TIMEOUT        then clearTimeout ref
    when INTERVAL       then clearInterval ref
    when REQUEST_FRAME  then clearAnimationFrame ref
