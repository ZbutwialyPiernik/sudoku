import 'dart:core';

import 'package:sudoku/model/cell.dart';

///
/// Checks if board is valid
/// @ignoreEmpty if true, then ignores empty space and considered as valid
///              if false, then empty space is considered as invalid
bool isValid(List<List<Cell>> board, bool ignoreEmpty) =>
    _checkSquares(board, ignoreEmpty) &&
    _checkColumns(board, ignoreEmpty) &&
    _checkRows(board, ignoreEmpty);

bool _checkSquares(List<List<Cell>> board, bool ignoreWhitespace) {
  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 3; x++) {
      if (!_checkSquare(board, Vector2D(x, y), ignoreWhitespace)) {
        return false;
      }
    }
  }

  return true;
}

bool _checkSquare(List<List<Cell>> board, Vector2D block, bool ignoreWhitespace) {
  Set<int> seen = Set();

  for (int y = block.y * 3; y < block.y * 3 + 3; y++) {
    for (int x = block.x * 3; x < block.x * 3 + 3; x++) {
      final cell = board[y][x];

      if (cell == null || cell.isEmpty) {
        if (ignoreWhitespace) {
          continue;
        } else {
          return false;
        }
      }

      if (!seen.add(cell.value)) {
        return false;
      }
    }
  }

  return true;
}

bool _checkRows(List<List<Cell>> board, bool ignoreWhitespace) {
  for (int y = 0; y < 9; y++) {
    Set<int> seen = Set();

    for (int x = 0; x < 9; x++) {
      final cell = board[y][x];

      if (cell == null || cell.isEmpty) {
        if (ignoreWhitespace) {
          continue;
        } else {
          return false;
        }
      }

      if (!seen.add(cell.value)) {
        return false;
      }
    }
  }

  return true;
}

bool _checkColumns(List<List<Cell>> board, bool ignoreWhitespace) {
  for (int x = 0; x < 9; x++) {
    Set<int> seen = Set();

    for (int y = 0; y < 9; y++) {
      final cell = board[y][x];

      if (cell == null || cell.isEmpty) {
        if (ignoreWhitespace) {
          continue;
        } else {
          return false;
        }
      }

      if (!seen.add(cell.value)) {
        return false;
      }
    }
  }

  return true;
}
