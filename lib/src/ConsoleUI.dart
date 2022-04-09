import "dart:io";
import 'package:main/src/Board.dart';

/// Interacts with the user (IO).
class ConsoleUI {
  var _board;

  set board(Board board) => _board = board;

  /// Prints the [msg] given by Controller.
  void showMessage(String msg) {
    print(msg);
  }

  /// Prompts the user for a url, if none given use [defaultUrl].
  String promptServer(String defaultUrl) {
    dynamic url;

    while (url != "") {
      print("Enter the server URL [default: $defaultUrl] ");
      url = stdin.readLineSync() as String;
      var valid = Uri.tryParse(url)?.hasAbsolutePath;

      if (valid ?? false) {
        return url;
      } else if (valid ?? true) {
        print("Invalid url ......");
      }
    }
    return defaultUrl;
  }

  /// Prompts the user for a strategy in [strategies].
  ///
  /// Uses [strategy] if none given. Throws a [FormatException]
  /// if user does not input an integer.
  String promptStrategy(strategies, String strategy) {
    dynamic selection;
    int strategyLen = strategies.length;

    while (selection != "") {
      print("Select the server strategy: 1. Smart 2. Random [default: 1] ");
      selection = stdin.readLineSync() as String;

      try {
        selection = int.parse(selection);

        if (selection - 1 < strategyLen && selection - 1 > -1) {
          return strategies[selection - 1];
        } else {
          print("Invalid selection: $selection");
        }
      } on FormatException {
        if (selection != "") {
          print("Invalid format!");
        }
      }
    }
    return strategy;
  }

  /// Prints the board to the user.
  void showBoard() {
    var indexes =
        List<int>.generate(_board.size, (i) => (i + 1) % 10).join(' ');
    stdout.writeln(' x $indexes');

    int y = 0;
    for (var row in _board.rows) {
      var line = row.map((player) => player.stone).join(' ');
      stdout.writeln("${(y + 1) % 10}| $line");
      y++;
    }
  }

  /// Prompts the user for a move.
  ///
  /// Throws a [FormatException] if user does not input an integer.
  /// Throws a [RangeError] if user inputs an inappropriate value for an index.
  /// Throws a [NotEmpty] if user attempts to place move in non empty spot.
  promptMove() {
    dynamic indices;
    dynamic row;
    dynamic col;

    while (true) {
      print("Enter x and y (1-15, e.g., 8 10):");
      var prompt = stdin.readLineSync() as String;

      try {
        indices = prompt.split(" ");
        row = indices[0];
        col = indices[1];

        row = int.parse(row) - 1;
        col = int.parse(col) - 1;

        if (row >= _board.size || row < 0) {
          throw FormatException();
        }

        if (col >= _board.size || col < 0) {
          throw FormatException();
        }

        // Checks if place is empty.
        if (_board.rows[row][col].stone != '.') {
          throw NotEmpty();
        }

        break;
      } on FormatException {
        print("Invalid index!");
      } on RangeError {
        print("Invalid index!");
      } on NotEmpty {
        NotEmpty ne = NotEmpty();
        print(ne.errMsg());
      } catch (e) {
        print("Invalid index!");
      }
    }
    indices = [row, col];
    return indices;
  }

  /// Updates board based on player and opponent moves.
  ///
  /// If game results in win or tie returns true otherwise false.
  bool updateBoard(
      List indices, won, row, List oppIndices, oppWon, oppRow, tie) {
    _board.rows[indices[0]][indices[1]].stone = 'O';
    if (oppIndices[0] != -1 && oppIndices[1] != -1) {
      _board.rows[oppIndices[0]][oppIndices[1]].stone = 'X';
    }

    if (won) {
      var pairs = splitToPairs(row);
      pairs.forEach((pair) => _board.rows[pair[0]][pair[1]].stone = 'W');
      showBoard();
      print("Won!");
      return true;
    }

    if (oppWon) {
      var pairs = splitToPairs(oppRow);
      pairs.forEach((pair) => _board.rows[pair[0]][pair[1]].stone = 'W');
      showBoard();
      print("Lost!");
      return true;
    }

    if (tie) {
      showBoard();
      print("Tie!");
      return true;
    }

    return false;
  }

  /// Given [row], splits it into pairs of size 2.
  splitToPairs(List row) {
    var pairs = [];
    int chunkSize = 2;
    int size = row.length;

    for (var i = 0; i < size; i += chunkSize) {
      pairs.add(row.sublist(i, i + chunkSize > size ? size : i + chunkSize));
    }
    return pairs;
  }
}

class NotEmpty implements Exception {
  String errMsg() => "Not empty!";
}
