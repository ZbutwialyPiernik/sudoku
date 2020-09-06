import 'dart:convert';
import 'dart:io' as dartIO;
import 'dart:html' as dartHTML;

import 'package:path_provider/path_provider.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';
import 'package:universal_platform/universal_platform.dart';

final _SudokuIO io = UniversalPlatform.isWeb ? _WebSudokuIO() : _MobileSudokuIO();

abstract class _SudokuIO {
  Future<void> deleteIfExists();

  Future<bool> isSaved();

  Future<SudokuSnapshot> load();

  Future<void> save(SudokuSnapshot snapshot);
}

const filename = "save.json";

class _WebSudokuIO extends _SudokuIO {
  Future<void> deleteIfExists() async {
    dartHTML.window.localStorage.remove(filename);
  }

  Future<bool> isSaved() async {
    return dartHTML.window.localStorage.containsKey(filename);
  }

  Future<SudokuSnapshot> load() async {
    return SudokuSnapshot.fromJson(jsonDecode(dartHTML.window.localStorage[filename]));
  }

  Future<void> save(SudokuSnapshot snapshot) async {
    dartHTML.window.localStorage[filename] = jsonEncode(snapshot.toJson());
  }
}

class _MobileSudokuIO extends _SudokuIO {
  _MobileSudokuIO();

  @override
  Future<SudokuSnapshot> load() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = dartIO.File("${directory.path}/$filename");

    return SudokuSnapshot.fromJson(jsonDecode(file.readAsStringSync()));
  }

  @override
  Future<void> save(SudokuSnapshot snapshot) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = dartIO.File("${directory.path}/$filename");

    file.writeAsString(jsonEncode(snapshot.toJson()));
  }

  @override
  Future<bool> isSaved() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = dartIO.File("${directory.path}/$filename");

    return file.exists();
  }

  @override
  Future<void> deleteIfExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = dartIO.File("${directory.path}/$filename");

    file.exists().then((exists) => file.delete());
  }
}
