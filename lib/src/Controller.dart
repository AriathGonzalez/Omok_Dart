import 'package:main/src/Board.dart';
import 'package:main/src/ConsoleUI.dart';
import 'package:main/src/WebClient.dart';

/// Coordinates tasks.
class Controller {
  start() async {
    var ui = ConsoleUI();
    ui.showMessage("Welcome to Omok game!");
    var url =
        ui.promptServer("https://www.cs.utep.edu/cheon/cs3360/project/omok/");
    ui.showMessage("Obtaining server information ......");
    var net = WebClient();
    var info = await net.getInfo(url);
    var strategy = ui.promptStrategy(info["strategies"], "Smart");
    ui.showMessage("Creating a new game ......");
    var game = await net.createNewGame(strategy); // Connect to new
    ui.board = Board(info["size"]);

    // Game keeps going until a Player has won or tie.
    while (true) {
      ui.showBoard();
      var indices = ui.promptMove();
      var result = await net.makeMove(game["pid"], indices); // Connect to play

      var ackMove = result["ack_move"];
      var move = result["move"];

      // Player
      var won = ackMove["isWin"];
      var x = ackMove['x'], y = ackMove['y'];
      var row = ackMove["row"];
      var tie = ackMove["tie"] != null ? true : false;

      // Opponent
      var oppWon = !won ? move["isWin"] : false;
      var oppX = !won ? move['x'] : -1;
      var oppY = !won ? move['y'] : -1;
      var oppRow = !won ? move["row"] : [];

      var end =
          ui.updateBoard([x, y], won, row, [oppX, oppY], oppWon, oppRow, tie);

      if (end) {
        break;
      }
    }
  }
}
