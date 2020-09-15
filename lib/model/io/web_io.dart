import 'dart:convert';
import 'dart:html' as dartHTML;

import 'package:sudoku/model/io/sudoku_io.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';

const key = "board";

class WebSudokuIO extends SudokuIO {
  Future<void> deleteIfExists() async {
    dartHTML.window.localStorage.remove(key);
  }

  Future<bool> isSaved() async {
    return dartHTML.window.localStorage.containsKey(key);
  }

  Future<SudokuSnapshot> load() async {
    return SudokuSnapshot.fromJson(jsonDecode(dartHTML.window.localStorage[key]));
  }

  Future<void> save(SudokuSnapshot snapshot) async {
    dartHTML.window.localStorage[key] = jsonEncode(snapshot.toJson());
  }
}

SudokuIO build() => WebSudokuIO();
