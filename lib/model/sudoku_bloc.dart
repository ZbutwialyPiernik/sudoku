import 'package:rxdart/rxdart.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/model/io/sudoku_io.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';
import 'package:sudoku/model/sudoku_validator.dart';

abstract class GameState {}

class GameRunning extends GameState {}

class GameEnded extends GameState {
  final Duration gameTime;

  GameEnded(this.gameTime);
}

class SudokuBloc {
  static const int size = 9;

  final Stopwatch _stopwatch = Stopwatch();
  final BehaviorSubject<GameState> _gameStateSubject =
      BehaviorSubject.seeded(GameRunning());

  Duration _timeElapsed;
  List<List<BehaviorSubject<Cell>>> _board;

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

  bool isLoaded() {
    return _board != null;
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

  Stream<Duration> get currentTime => Stream<Duration>.periodic(
      Duration(milliseconds: 500),
      (index) => GameState is GameRunning ? _timeElapsed + _stopwatch.elapsed : null);

  Stream<Cell> cell(Vector2D position) => _board[position.y][position.x].stream;

  Stream<GameState> get gameState => _gameStateSubject.stream;

  void updateCellWithValue(Vector2D position, int value) {
    final cellSubject = _board[position.y][position.x];

    if (cellSubject.value.value == value) {
      value = 0;
    }

    cellSubject.add(Cell.normal(position, value));

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

  Cell _updateCellWithTip(Cell cell, int value) {
    final List<int> newTips = cell.tips == null ? List() : List.from(cell.tips);

    newTips.contains(value) ? newTips.remove(value) : newTips.add(value);

    return newTips.isEmpty
        ? Cell.empty(cell.position)
        : Cell.withTips(cell.position, newTips);
  }

  void dispose() {
    if (!(_gameStateSubject.value is GameEnded)) {
      io.save(takeSnapshot());
    }

    _stopwatch.stop();
    _stopwatch.reset();
    _gameStateSubject.close();
    _board.forEach((row) => row.forEach((cell) => cell.close()));
  }

  _removeTipsInRow(Vector2D position, int valueToRemove) {
    for (int i = 0; i < size; i++) {
      final cellSubject = _board[position.y][i];
      final cell = cellSubject.value;

      if (position.x != i && cell.hasTips && cell.tips.contains(valueToRemove)) {
        cellSubject.add(_updateCellWithTip(cell, valueToRemove));
      }
    }
  }

  _removeTipsInColumn(Vector2D position, int valueToRemove) {
    for (int i = 0; i < size; i++) {
      final cellSubject = _board[i][position.x];
      final cell = cellSubject.value;

      if (position.y != i && cell.hasTips && cell.tips.contains(valueToRemove)) {
        cellSubject.add(_updateCellWithTip(cell, valueToRemove));
      }
    }
  }
}
