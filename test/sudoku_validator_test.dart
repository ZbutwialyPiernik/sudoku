import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/model/sudoku_validator.dart';

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

final emptyFields = [
  [5, 9, 2, 4, 6, 3, 8, 1, 7],
  [1, 7, 3, 9, 2, 8, 5, 4, 6],
  [4, 8, 0, 5, 1, 7, 9, 2, 3],
  [6, 2, 5, 0, 4, 1, 3, 7, 9],
  [8, 3, 0, 2, 7, 5, 4, 6, 1],
  [7, 1, 4, 3, 9, 6, 2, 5, 8],
  [3, 4, 1, 7, 8, 2, 6, 9, 5],
  [2, 6, 8, 1, 5, 9, 7, 3, 4],
  [9, 5, 7, 6, 3, 4, 1, 8, 2],
];

final reapeatingInSquare = [
  [5, 9, 2, 4, 6, 3, 8, 1, 7],
  [1, 5, 3, 9, 2, 8, 5, 4, 6],
  [4, 8, 6, 5, 1, 7, 9, 2, 3],
  [6, 2, 5, 8, 4, 1, 3, 7, 9],
  [8, 3, 9, 2, 7, 5, 4, 6, 1],
  [7, 1, 4, 3, 9, 6, 2, 5, 8],
  [3, 4, 1, 7, 8, 2, 6, 9, 5],
  [2, 6, 8, 1, 5, 9, 7, 3, 4],
  [9, 5, 7, 6, 3, 4, 1, 8, 2],
];

final reapeatingInRow = [
  [5, 9, 2, 4, 6, 3, 5, 1, 7],
  [1, 5, 3, 9, 2, 8, 5, 4, 6],
  [4, 8, 6, 5, 1, 7, 9, 2, 3],
  [6, 2, 5, 8, 4, 1, 3, 7, 9],
  [8, 3, 9, 2, 7, 5, 4, 6, 1],
  [7, 1, 4, 3, 9, 6, 2, 5, 8],
  [3, 4, 1, 7, 8, 2, 6, 9, 5],
  [2, 6, 8, 1, 5, 9, 7, 3, 4],
  [9, 5, 7, 6, 3, 4, 1, 8, 2],
];

final reapeatingInColumn = [
  [5, 9, 2, 4, 6, 3, 8, 1, 7],
  [1, 5, 3, 9, 2, 8, 5, 4, 6],
  [5, 8, 6, 5, 1, 7, 9, 2, 3],
  [6, 2, 5, 8, 4, 1, 3, 7, 9],
  [8, 3, 9, 2, 7, 5, 4, 6, 1],
  [7, 1, 4, 3, 9, 6, 2, 5, 8],
  [3, 4, 1, 7, 8, 2, 6, 9, 5],
  [2, 6, 8, 1, 5, 9, 7, 3, 4],
  [9, 5, 7, 6, 3, 4, 1, 8, 2],
];

final reapeatingInRowWithWhitespace = [
  [1, 2, 3, 4, 4, 5, 6, 7, 8],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
];

List<List<Cell>> mapToCells(List<List<int>> cells) {
  return cells
      .map((row) => row.map((cell) => Cell.normal(Vector2D(0, 0), cell)).toList())
      .toList();
}

void main() {
  test('When sudoku is valid returns true', () {
    expect(isValid(mapToCells(validSudoku), false), true);
  });

  test('When sudoku has empty fields returns false', () {
    expect(isValid(mapToCells(emptyFields), false), false);
  });

  test('When sudoku has reapeating number in square returns false', () {
    expect(isValid(mapToCells(reapeatingInSquare), false), false);
  });

  test('When sudoku has reapeating number in column returns false', () {
    expect(isValid(mapToCells(reapeatingInColumn), false), false);
  });

  test('When sudoku has reapeating number in row returns false', () {
    expect(isValid(mapToCells(reapeatingInRow), false), false);
  });
}
