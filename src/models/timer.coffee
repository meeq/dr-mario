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

if performance?
  hiResNow =
    performance.now ?
    performance.mozNow ?
    performance.msNow ?
    performance.oNow ?
    performance.webkitNow

if hiResNow?
  exports.now = hiResNow.bind performance
else
  exports.now = Date.now ? -> new Date().getTime()

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
    when TIMEOUT
      setTimeout callback, interval
    when INTERVAL
      setInterval callback, interval
    when REQUEST_FRAME
      if requestAnimationFrame? then requestAnimationFrame callback
      else setTimeout callback, interval

exports.stop = (method, ref) ->
  switch method
    when TIMEOUT
      clearTimeout ref
    when INTERVAL
      clearInterval ref
    when REQUEST_FRAME
      if cancelAnimationFrame? then cancelAnimationFrame ref
      else clearTimeout ref
  return
