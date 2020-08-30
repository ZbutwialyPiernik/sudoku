import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';

final validSudoku = [
  [5, 9, 2, 4, 6, 3, 8, 1, 7],
  [1, 7, 3, 9, 2, 8, 5, 4, 6],
  [4, 8, 6, 5, 1, 7, 9, 2, 3],
  [6, 2, 5, 8, 4, 1, 3, 7, 9],
  [8, 3, 9, 2, 7, 5, 4, 6, 1],
  [7, 1, 4, 3, 9, 6, 2, 5, 8],
  [3, 4, 1, 7, 8, 2, 6, 9, 5],
  [2, 6, 8, 1, 5, 9, 7, 3, 4],
  [9, 5, 7, 6, 3, 4, 1, 8, 2],
];

List<List<Cell>> mapToCells(List<List<int>> cells) {
  return cells
      .map((row) => row.map((cell) => Cell.normal(Vector2D(0, 0), cell)).toList())
      .toList();
}

final snapshot = SudokuSnapshot(
    board: mapToCells(validSudoku), timeElapsed: const Duration(seconds: 5));

void main() {
  test('Serialization is correct and bidirectional', () {
    final deserializedSnapshot = SudokuSnapshot.fromJson(snapshot.toJson());
    expect(
      deserializedSnapshot,
      snapshot,
    );
  });
}
