import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sudoku/model/cell.dart';

class SudokuSnapshot extends Equatable {
  final List<List<Cell>> board;
  final Duration timeElapsed;

  SudokuSnapshot({
    this.board,
    this.timeElapsed = Duration.zero,
  })  : assert(board != null),
        assert(timeElapsed != null);

  int get emptyFields {
    int count = 0;

    board.forEach(
      (row) => row.forEach(
        (cell) {
          if (cell.value == 0) count++;
        },
      ),
    );

    return count;
  }

  static SudokuSnapshot fromJson(Map<String, dynamic> json) {
    return SudokuSnapshot(
      board: List<List<dynamic>>.from(json['board'])
          .map((row) => row.map((json) => Cell.fromJson(json)).toList())
          .toList(),
      timeElapsed: Duration(milliseconds: json['timeElapsed']),
    );
  }

  Map<String, dynamic> toJson() => {
        'board': board.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
        'timeElapsed': timeElapsed.inMilliseconds,
      };

  @override
  List<Object> get props => [board, timeElapsed];

  @override
  bool get stringify => true;
}

int getCountOfNumber(List<List<Cell>> board, int number) {
  int count = 0;

  board.forEach(
    (row) => row.forEach(
      (cell) {
        if (cell.value == number) {
          count++;
        }
      },
    ),
  );

  return count;
}

List<List<BehaviorSubject<Cell>>> wrapCells(List<List<Cell>> board) =>
    board.map((row) => row.map((cell) => BehaviorSubject.seeded(cell)).toList()).toList();

List<List<Cell>> unwrapCells(List<List<BehaviorSubject<Cell>>> board) =>
    board.map((row) => row.map((cell) => cell.value).toList()).toList();
