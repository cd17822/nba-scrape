router = (require 'express').Router()
request = require 'request'
rek = require 'rekuire'
Player = rek 'models/player'
Game = rek 'models/game'

router.get '/', (req, res, next) ->
  res.render 'index', title: 'nba-scrape' #render page and then go about processing...

  for letter in "abcdefghijklmnopqrstuvwxyz"
    request
      url: "http://www.basketball-reference.com/players/#{letter}/"
      method: 'GET'
      (err, response, body) ->
        if err then console.log err
        else if response.statusCode isnt 200 then console.log body
        else findPlayers body, letter

findPlayers = (html, letter) ->
  links = []
  start = html.indexOf("<a href=\"/players/#{letter}") + '<a href="'.length
  s = start
  f = html.indexOf '">', s
  table_end = html.indexOf "</tbody>", s

  links.push "http://www.basketball-reference.com" + (html.substring s, f)

  while f+10 < table_end and s > -1 and s >= start
    s = html.indexOf("<a href=\"/players/#{letter}", f) + '<a href="'.length
    f = html.indexOf '">', s
    links.push "http://www.basketball-reference.com" + (html.substring s, f)

  for link in links
    request
      url: link
      method: 'GET'
      (err, response, body) ->
        if err then console.log err
        else if response.statusCode isnt 200 then console.log body
        else findLogs body, letter

findLogs = (html, letter) ->
  links = []
  logs_begin = html.indexOf '<li><span class="like_a">Game Logs<span class="arrowsprite_bottom"></span></span>'
  start = html.indexOf('href="', logs_begin) + 'href="'.length
  s = start
  f = html.indexOf '">', s
  table_end = html.indexOf "</ul>", s

  links.push "http://www.basketball-reference.com" + html.substring s, f

  while f+10 < table_end and s > -1 and s >= start
    s = html.indexOf('<a href="', f) + '<a href="'.length
    f = html.indexOf '">', s
    links.push "http://www.basketball-reference.com" + (html.substring s, f)

  name_start = (html.indexOf '<h1>') + '<h1>'.length
  name = html.substring name_start, (html.indexOf '<', name_start)

  player = new Player name: name
  player.save (err) ->
    if err then console.log err
    else
      for link in links
        request
          url: link
          method: 'GET'
          (err, response, body) ->
            if err then console.log err
            else if response.statusCode isnt 200 then console.log body
            else findGames body, player.id

findGames = (html, playerId) ->
  rows = []
  s = html.indexOf '<td><a href="/boxscores/'
  f = html.indexOf '</tbody>', s
  while s+5 < f and s > -1
    s = readRow html, s, playerId

readRow = (html, s, playerId) ->
  # @TODO: assign each element in a <td></td> to a field of a Game object (unfinished)
  s = html.indexOf '<td><a href="/boxscores/', s
  row_end = html.indexOf '</tr>', s
  fin = html.indexOf '<', s+1

  while s < row_end and s > -1 and fin < row_end and s < fin
    s = html.indexOf '>', s+1
    fin = html.indexOf '<', s+1

    if fin-s > 1 then console.log html.substring s+1, fin

  console.log "---------"

  return row_end

module.exports = router
