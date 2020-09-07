import 'dart:convert';
import 'dart:io' as dartIO;

import 'package:path_provider/path_provider.dart';
import 'package:sudoku/model/io/sudoku_io.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';

const filename = "save.json";

class MobileSudokuIO extends SudokuIO {
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

SudokuIO build() => MobileSudokuIO();
