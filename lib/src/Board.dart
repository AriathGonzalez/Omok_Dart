class Board {
  final size;
  var rows;

  Board(this.size) {
    rows = List.generate(size, (i) => List.generate(size, (j) => Player('.')));
  }
}

class Player {
  String stone;

  Player(this.stone);

  @override
  String toString() => stone;
}
