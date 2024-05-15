import 'dart:math';

// Define a class to represent the XOX game board
class AIPlayer {
  List<List<String>> cells;
  String robot='X';
  String user='O';

  AIPlayer(this.cells);

  // Check if the board is full
  bool isFull() {
    return cells.every((row) => row.every((cell) => cell != ''));
  }

  // Check if the game is over (someone won or the board is full)
  bool gameOver() {
    return checkWinner(robot) || checkWinner(user) || isFull();
  }

  //setRobotValue
  void setRobot(String robot){
    this.robot=robot;
  }

  //setUser
  void setUser(String user){
    this.user=user;
  }

  // Check if the specified player has won
  bool checkWinner(String player) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (cells[i][0] == player && cells[i][1] == player && cells[i][2] == player) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (cells[0][i] == player && cells[1][i] == player && cells[2][i] == player) {
        return true;
      }
    }

    // Check diagonals
    if (cells[0][0] == player && cells[1][1] == player && cells[2][2] == player) {
      return true;
    }
    if (cells[0][2] == player && cells[1][1] == player && cells[2][0] == player) {
      return true;
    }

    return false;
  }

  // Make a move on the board
  void makeMove(int row, int col, String player) {
    cells[row][col] = player;
  }

  // Get available moves
  List<Point<int>> availableMoves() {
    List<Point<int>> moves = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (cells[i][j] == '') {
          moves.add(Point(i, j));
        }
      }
    }
    return moves;
  }


// Minimax algorithm with alpha-beta pruning
  int minimax(AIPlayer board, int depth, bool isMaximizingPlayer, int alpha, int beta) {
    if (board.gameOver() || depth == 0) {
      if (board.checkWinner(robot)) {
        return 10;
      } else if (board.checkWinner(user)) {
        return -10;
      }
      return 0;
    }

    if (isMaximizingPlayer) {
      int maxEval = -1000;
      for (var move in board.availableMoves()) {
        board.makeMove(move.x, move.y, robot);
        int eval = minimax(board, depth - 1, !isMaximizingPlayer, alpha, beta);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        board.makeMove(move.x, move.y, ''); // Undo move
        if (beta <= alpha) {
          break; // Beta cut-off
        }
      }
      return maxEval;
    } else {
      int minEval = 1000;
      for (var move in board.availableMoves()) {
        board.makeMove(move.x, move.y, user);
        int eval = minimax(board, depth - 1, !isMaximizingPlayer, alpha, beta);
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        board.makeMove(move.x, move.y, ''); // Undo move
        if (beta <= alpha) {
          break; // Alpha cut-off
        }
      }
      return minEval;
    }
  }
}
