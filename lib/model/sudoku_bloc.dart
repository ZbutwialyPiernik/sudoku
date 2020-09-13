import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/model/io/sudoku_io.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';
import 'package:sudoku/model/sudoku_validator.dart';

abstract class GameState {}

class GameRunning extends GameState {}

class GamePaused extends GameState {}

class GameEnded extends GameState {
  final Duration gameTime;

  GameEnded(this.gameTime);
}

class SudokuBloc {
  static const int boardSize = 9;

  final Stopwatch _stopwatch = Stopwatch();
  final BehaviorSubject<GameState> _gameStateSubject =
      BehaviorSubject.seeded(GameRunning());
  final BehaviorSubject<bool> _undoSubject = BehaviorSubject.seeded(false);

  final Queue<List<List<Cell>>> _previousStates = Queue<List<List<Cell>>>();

  Duration _timeElapsed;
  List<List<BehaviorSubject<Cell>>> _board;

  Stream<Duration> get currentTime => Stream<Duration>.periodic(
      Duration(milliseconds: 500),
      (index) => GameState is GameRunning ? _timeElapsed + _stopwatch.elapsed : null);

  Stream<Cell> cell(Vector2D position) => _board[position.y][position.x].stream;

  Stream<GameState> get gameState => _gameStateSubject.stream;

  Stream<bool> get isAbleToUndo => _undoSubject.stream;

  bool get isLoaded => _board != null;

  void load(SudokuSnapshot snapshot) {
    _board = wrapCells(snapshot.board);
    _timeElapsed = snapshot.timeElapsed;
  }

  void resume() {
    _stopwatch.start();
  }

  void pause() {
    _stopwatch.stop();
  }

  void updateCellWithValue(Vector2D position, int value) {
    final cellSubject = _board[position.y][position.x];

    _previousStates.addLast(unwrapCells(_board));

    if (cellSubject.value.value == value) {
      value = 0;
    }

    cellSubject.add(Cell.normal(position, value));
    _undoSubject.add(true);

    _removeTipsInRow(position, value);
    _removeTipsInColumn(position, value);

    if (isValid(unwrapCells(_board), false)) {
      io.deleteIfExists();

      _gameStateSubject.add(GameEnded(_stopwatch.elapsed + _timeElapsed));
    }
  }

  void updateCellWithTip(Vector2D position, int value) {
    final cellSubject = _board[position.y][position.x];
    final cell = cellSubject.value;

    cellSubject.add(_updateCellWithTip(cell, value));
  }

  void undo() {
    final previousState = _previousStates.removeLast();

    for (int y = 0; y < boardSize; y++) {
      for (int x = 0; x < boardSize; x++) {
        final cellSubject = _board[y][x];
        final previousCellState = previousState[y][x];

        if (cellSubject.value != previousCellState) {
          _board[y][x].add(previousCellState);
        }
      }
    }

    if (_undoSubject.value != _previousStates.isNotEmpty) {
      _undoSubject.add(_previousStates.isNotEmpty);
    }
  }

  void reset() {
    _board.forEach(
      (row) => row.forEach((cell) {
        if (!cell.value.isEmpty && !cell.value.isSolid) {
          cell.add(Cell.empty(cell.value.position));
        }
      }),
    );
    _stopwatch.reset();
    _timeElapsed = Duration.zero;
  }

  SudokuSnapshot takeSnapshot() {
    return SudokuSnapshot(
        board: unwrapCells(_board), timeElapsed: _timeElapsed + _stopwatch.elapsed);
  }

  void dispose() {
    if (!(_gameStateSubject.value is GameEnded)) {
      io.save(takeSnapshot());
    }

    _stopwatch.stop();
    _stopwatch.reset();
    _gameStateSubject.close();
    _undoSubject.close();
    _board.forEach((row) => row.forEach((cell) => cell.close()));
  }

  Cell _updateCellWithTip(Cell cell, int value) {
    final List<int> newTips = cell.tips == null ? List() : List.from(cell.tips);

    newTips.contains(value) ? newTips.remove(value) : newTips.add(value);

    return newTips.isEmpty
        ? Cell.empty(cell.position)
        : Cell.withTips(cell.position, newTips);
  }

  _removeTipsInRow(Vector2D position, int valueToRemove) {
    for (int i = 0; i < boardSize; i++) {
      final cellSubject = _board[position.y][i];
      final cell = cellSubject.value;

      if (position.x != i && cell.hasTips && cell.tips.contains(valueToRemove)) {
        cellSubject.add(_updateCellWithTip(cell, valueToRemove));
      }
    }
  }

  _removeTipsInColumn(Vector2D position, int valueToRemove) {
    for (int i = 0; i < boardSize; i++) {
      final cellSubject = _board[i][position.x];
      final cell = cellSubject.value;

      if (position.y != i && cell.hasTips && cell.tips.contains(valueToRemove)) {
        cellSubject.add(_updateCellWithTip(cell, valueToRemove));
      }
    }
  }
}
