exports.LO  = LO  = 0 | 0
exports.MED = MED = 1 | 0
exports.HI  = HI  = 2 | 0

exports.options = options = ['lo', 'med', 'hi']

exports.fromOption = (speedOption) ->
  index | 0 if 0 <= (index = options.indexOf speedOption)

exports.calculateTickRate = (speed, count) ->
  speed = speed | 0
  count = count | 0
  switch speed
    when LO  then base = 15 | 0
    when MED then base = 25 | 0
    when HI  then base = 31 | 0
  index = (base + count) | 0
  if      index <= 25 then ((35 - index) * 2 - 1) | 0
  else if index <= 34 then           (44 - index) | 0
  else if index <= 36 then                      9 | 0
  else if index <= 38 then                      8 | 0
  else if index <= 40 then                      7 | 0
  else if index <= 42 then                      6 | 0
  else if index <= 54 then                      5 | 0
  else if index <= 59 then                      4 | 0
  else if index <= 64 then                      3 | 0
  else if index <= 69 then                      2 | 0
  else                                          1 | 0

exports.baseScoreCombo = (speed) ->
  speed = speed | 0
  switch speed
    when LO  then 1 | 0
    when MED then 2 | 0
    when HI  then 3 | 0
