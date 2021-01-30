import parseutils
import random
import sequtils

const
  squareRoot = 3
  squareNumber = squareRoot * squareRoot
  winPatternNum = 8

type
  SquareState = enum
    Empty = "_",
    Human = "O",
    Cpu = "X",

type
  Game = object
    board: array[squareNumber, SquareState]
    turnCount: int8
    winPattern: array[winPatternNum, array[squareRoot, int8]]

proc initGame(): Game =
  randomize()
  result.board = [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
  result.turnCount = 0
  result.winPattern = [
    [0'i8, 1, 2],
    [3'i8, 4, 5],
    [6'i8, 7, 8],
    [0'i8, 3, 6],
    [1'i8, 4, 7],
    [2'i8, 5, 8],
    [0'i8, 4, 8],
    [2'i8, 4, 6],
    ]

proc printBoard(g: Game, label: string) =
  stdout.writeLine label
  for i in 0..<squareRoot:
    for j in 0..<squareRoot:
      stdout.write squareRoot*i+j
    stdout.write " "
    for j in 0..<squareRoot:
      stdout.write g.board[squareRoot*i+j]
    stdout.write "\n"

proc humanThinking(g: Game): int8 =
  var pos: int
  while true:
    write(stdout, ">> ")
    try: parseInt(readLine(stdin), pos, 0)
    except: continue
    if pos < 0 or squareNumber - 1 < pos or g.board[pos] != Empty:
      continue
    break
  result = cast[int8](pos)

proc humanTurn(g: var Game) =
  let pos = g.humanThinking()
  g.board[pos] = Human

proc cpuThinking(g: Game): int8 =
  var list: seq[int8]
  for i, state in g.board:
    if state == Empty:
      list.add(i)
  shuffle(list)
  result = list[0]

proc cpuTurn(g: var Game) =
  let pos = g.cpuThinking()
  g.board[pos] = Cpu

proc isDrawn(g: Game): bool =
  result = g.turnCount == squareNumber

proc whosTurn(g: Game): SquareState =
  if (g.turnCount mod 2) == 0:
    return Human
  result = Cpu

proc isFinished(g: Game): bool =
  let who = g.whosTurn()
  for pattern in g.winPattern:
    if all(pattern, proc (x: int8): bool = return g.board[x] == who):
      return true
  result = false

proc main() =
  var g = initGame()

  g.printBoard("- Game Starts -")

  while g.turnCount < squareNumber:

    g.humanTurn()
    g.printBoard("- Your turn -")
    if g.isFinished():
      echo "# You Win #"
      return
    g.turnCount += 1

    if g.isDrawn():
      echo "# draw #"
      return

    g.cpuTurn()
    g.printBoard("- CPU's turn -")
    if g.isFinished():
      echo "# You Lose #"
      return
    g.turnCount += 1

main()
