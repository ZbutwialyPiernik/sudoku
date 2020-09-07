import 'package:universal_platform/universal_platform.dart';
import 'package:sudoku/model/io/mobile_io.dart'
    if (UniversalPlatform.isWeb) 'package:sudoku/model/io/web_io.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';

final SudokuIO io = build();

abstract class SudokuIO {
  Future<void> deleteIfExists();

  Future<bool> isSaved();

  Future<SudokuSnapshot> load();

  Future<void> save(SudokuSnapshot snapshot);
}
