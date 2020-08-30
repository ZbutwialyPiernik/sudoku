import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';

final SudokuIO io =
    Platform.isAndroid || Platform.isIOS || Platform.isLinux || Platform.isMacOS
        ? MobileSudokuIO()
        : null;

abstract class SudokuIO {
  Future<void> deleteIfExists();

  Future<bool> isSaved();

  Future<SudokuSnapshot> load();

  Future<void> save(SudokuSnapshot snapshot);
}

class MobileSudokuIO extends SudokuIO {
  MobileSudokuIO();

  @override
  Future<SudokuSnapshot> load() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/save.json");

    return SudokuSnapshot.fromJson(jsonDecode(file.readAsStringSync()));
  }

  @override
  Future<void> save(SudokuSnapshot snapshot) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/save.json");

    file.writeAsString(jsonEncode(snapshot.toJson()));
  }

  @override
  Future<bool> isSaved() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/save.json");

    return file.exists();
  }

  @override
  Future<void> deleteIfExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/save.json");

    file.exists().then((exists) => file.delete());
  }
}
