shuffle = (o) ->
  j = undefined
  x = undefined
  i = o.length

  while i
    j = Math.floor Math.random() * i
    x = o[--i]
    o[i] = o[j]
    o[j] = x
  o


random = ->
  loop
    test = Math.floor Math.random() * 11
    break if test isnt 0
  test


getop = ->
  shuffle(['+', '-', '*', '/']).pop()


oper = (a, op, b) ->
  switch op
    when '+' then a + b
    when '-' then a - b
    when '/' then a / b
    when '*' then a * b


main = ->
  document.body.innerHTML += JST['app/templates/main.us']()

  body = document.body
  list = document.getElementById 'math'
  face = document.getElementById 'face'
  stats = document.getElementById 'stats'
  result = document.getElementById 'result'
  buttons = document.getElementsByTagName 'button'

  operator = null
  ticker = null
  bad = 0
  ok = 0

  fill = ->
    operator = getop()
    left_value = random()
    right_value = random()
    result_value = Math.round oper(left_value, operator, right_value)

    list.innerHTML = ''
    list.innerHTML += '<li>' + left_value + '</li>'
    list.innerHTML += '<li>' + right_value + '</li>'

    face.innerHTML = ''
    result.innerHTML = result_value
    stats.innerHTML = "<span>✓ #{ok}</span> <span>✗ #{bad}</span>"

    clearTimeout(ticker) if ticker
    ticker = setTimeout ->
      answer off
    , 3600

  answer = (solved) ->
    if solved
      ok += 1
      klass = 'right'
      face.innerHTML = '☺'
    else
      bad += 1
      klass = 'badly'
      face.innerHTML = '☹'

    body.classList.add klass

    setTimeout ->
      body.classList.remove klass
      fill()
    , 400

  resolve = (e) ->
    switch e.target.id
      when 'plus' then answer operator is '+'
      when 'minus' then answer operator is '-'
      when 'divide' then answer operator is '/'
      when 'times' then answer operator is '*'

  for button in buttons
    if button.addEventListener
      button.addEventListener 'click', resolve, off
    else
      button.attachEvent 'click', resolve

  fill()


if window.addEventListener
  window.addEventListener 'DOMContentLoaded', main, off
else
  window.attachEvent 'load', main
