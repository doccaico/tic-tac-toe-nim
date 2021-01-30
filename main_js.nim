import dom
import random
import sequtils
import sugar

template debugLog(msg: string): untyped =
  when not defined(release): log(msg)

const
  squareRoot = 3
  squareNumber = squareRoot * squareRoot
  winPatternNum = 8

type
  SquareState = enum
    Empty,
    Human = "O",
    Cpu = "X",

type
  Game = object
    board: array[squareNumber, SquareState]
    turnCount: int
    winPattern: array[winPatternNum, array[squareRoot, cint]]
    currentPos: cint
    stop: bool
    event: Event

proc boardInit(g: var Game)
proc changeMessage(msg: string)

proc initGame(event: Event): Game =
  randomize()
  result.board = [Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty]
  result.turnCount = 0
  result.currentPos = 0
  result.winPattern = [
    [0.cint, 1, 2], [3.cint, 4, 5], [6.cint, 7, 8],
    [0.cint, 3, 6], [1.cint, 4, 7], [2.cint, 5, 8],
    [0.cint, 4, 8], [2.cint, 4, 6],
    ]
  result.event = event
  result.stop = false

proc humanTurn(g: var Game) =
  let pos = g.currentPos
  g.board[pos] = Human

proc cpuThinking(g: Game): cint =
  var list: seq[cint]
  for i, state in g.board:
    if state == Empty:
      list.add(i)
  shuffle(list)
  result = list[0]

proc cpuTurn(g: var Game) =
  let pos = g.cpuThinking()
  g.board[pos] = Cpu
  g.currentPos = pos

proc isDrawn(g: Game): bool =
  result = g.turnCount == squareNumber

proc whosTurn(g: Game): SquareState =
  if (g.turnCount mod 2) == 0:
    return Human
  result = Cpu

proc isFinished(g: Game): bool =
  let who = g.whosTurn()
  for pattern in g.winPattern:
    if all(pattern, proc (x: cint): bool = return g.board[x] == who):
      return true
  result = false

proc renderMark(g: Game) =
  var span = document.createElement("span")
  span.id = "square" & $g.currentPos
  getElementById($g.currentPos).appendChild(span)
  let mark = g.whosTurn()
  span.appendChild(document.createTextNode($mark))
  debugLog(g.board.repr)

proc resetGame(g: var Game) =
  document.querySelector("INPUT").remove()
  document.querySelector("TABLE").remove()
  document.querySelector("P").remove()
  g = initGame(g.event)
  g.boardInit()

proc forwardGame(g: var Game, event: Event) =

  g.humanTurn()
  g.renderMark()
  if g.isFinished():
    changeMessage("# You Win #")
    g.stop = true
    return
  g.turnCount += 1

  if g.isDrawn():
    changeMessage("# draw #")
    g.stop = true
    return

  g.cpuTurn()
  g.renderMark()
  if g.isFinished():
    changeMessage("# You Lose #")
    g.stop = true
    return
  g.turnCount += 1

proc createMessage(msg: string) =
  let msg = document.createTextNode(msg)
  var p = document.createElement("P")
  p.appendChild(msg)
  document.getElementById("board").appendChild(p)

proc createButton(g: var Game, label: string) =
  var btn = document.createElement("INPUT")
  btn.setAttribute("type", "button")
  btn.value = label
  btn.onclick = proc (event: Event) = g.resetGame()
  document.getElementById("board").appendChild(btn)

proc createTable(g: var Game) =
  var table = document.createElement("TABLE")
  var tableBody = document.createElement("TBODY")
  table.appendChild(tableBody)
  for i in 0..<squareRoot:
    var tr = document.createElement("TR")
    tableBody.appendChild(tr)
    for j in 0..<squareRoot:
      var td = document.createElement("TD")
      let pos = (i*3 + j).cint
      td.id = $pos # <td id="0"> "1", "2"

      capture pos:
        td.onclick = proc (event: Event) =
          if not g.stop and g.board[pos] == Empty:
            g.currentPos = pos
            g.forwardGame(g.event)

      tr.appendChild(td)
  document.getElementById("board").appendChild(table)

proc changeMessage(msg: string) =
  document.querySelector("P").remove()
  createMessage(msg)
  debugLog(msg)

proc boardInit(g: var Game) =
  g.createButton("Clear")
  g.createTable()
  createMessage("- Playing -")

proc main(event: Event) =
  randomize()
  var g = initGame(event)
  g.boardInit()

window.onload = main
