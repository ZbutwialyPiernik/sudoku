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

  void updateCell(Vector2D position, int value) {
    final cellSubject = _board[position.y][position.x];

    assert(!cellSubject.value.isSolid);

    cellSubject.add(Cell.normal(position, value));

    if (isValid(unwrapCells(_board), false)) {
      io.deleteIfExists();

      _gameStateSubject.add(GameEnded(_stopwatch.elapsed + _timeElapsed));
    }
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
}
