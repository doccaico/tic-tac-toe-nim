import ./game

proc printBoard(g: Game, label: string) =
  stdout.writeLine label
  for i in 0..<squareRoot:
    for j in 0..<squareRoot:
      stdout.write squareRoot*i+j
    stdout.write " "
    for j in 0..<squareRoot:
      stdout.write g.board[squareRoot*i+j]
    stdout.write "\n"

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
