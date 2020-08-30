import 'dart:math';

import 'package:sudoku/model/cell.dart';
import 'package:sudoku/model/sudoku_validator.dart';

const _size = 9;

final random = Random.secure();

List<List<Cell>> generateBoard(int solidCells) {
  List<List<Cell>> board = List.generate(_size, (i) => List(_size), growable: false);

  _fill(board, 0);
  _removeRandomNumbers(board, _size * _size - solidCells);

  return board;
}

bool _fill(List<List<Cell>> board, int index) {
  if (index == _size * _size) {
    return true;
  }

  final x = index % _size;
  final y = index ~/ _size;

  final cell = board[y][x];

  if (cell != null) {
    return _fill(board, index + 1);
  }

  List<int> availableNumbers = _getArrayInRange(1, _size)..shuffle();

  for (final number in availableNumbers) {
    board[y][x] = Cell.solid(Vector2D(x, y), number);

    if (isValid(board, true)) {
      if (_fill(board, index + 1)) {
        return true;
      }
    }

    board[y][x] = null;
  }

  return false;
}

void _removeRandomNumbers(List<List<Cell>> board, int numbersToRemove) {
  final x = random.nextInt(_size);
  final y = random.nextInt(_size);
  final cell = board[y][x];

  if (cell != null && !cell.isEmpty) {
    board[y][x] = Cell.empty(Vector2D(x, y));
    numbersToRemove--;
  }

  if (numbersToRemove > 0) {
    _removeRandomNumbers(board, numbersToRemove);
  }
}

List<int> _getArrayInRange(int min, int max) {
  return List.generate((max - min + 1).abs(), (index) => index + min);
}

void _drawBoard(List<List<Cell>> board) {
  var printedBoard = "";
  board.forEach((row) => printedBoard +=
      "[${row.map((cell) => cell != null ? cell.value : 'n').join(", ")}]\n");

  print(
      "---------------------------------\n$printedBoard---------------------------------");
}
