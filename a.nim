import strformat

const
  boardSize = 3
  boardLen = boardSize * boardSize
  winPatternNum = 8


type
  SquareState = enum
    Empty = "_",
    Human = "O",
    Cpu = "X",
type
  Game = object
    board: array[boardLen, SquareState]
    turnCount: int8

proc initGame(): Game =
  result.board = [Human,Human,Human,
                  Empty,Empty,Cpu,
                  Cpu,Empty,Empty]
  result.turnCount = 0

proc printBoard(g: Game) =
  for i in 0..<boardSize:
    for j in 0..<boardSize:
      stdout.write boardSize*i+j
    stdout.write " "
    for j in 0..<boardSize:
      stdout.write g.board[boardSize*i+j]
    stdout.write "\n"

var g = initGame()
g.printBoard()
