import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/model/io/sudoku_io.dart';
import 'package:sudoku/model/sudoku_generator.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';
import 'package:sudoku/view/sudoku_dialog.dart';

import 'package:sudoku/view/sudoku_page.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int y = 0; y < 3; y++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int x = 0; x < 3; x++)
                          Container(
                            decoration: BoxDecoration(
                                color: (x == 0 || x == 2) && (y == 0 || y == 2) ||
                                        (x == 1 && y == 1)
                                    ? lighterTileColor
                                    : darkerTileColor,
                                borderRadius: BorderRadius.all(Radius.circular(4))),
                            width: 64,
                            height: 64,
                          ),
                      ],
                    )
                ],
              ),
            ),
            SizedBox(height: 48),
            FutureBuilder<bool>(
              future: io.isSaved(),
              builder: (context, snapshot) {
                final isSaved = snapshot.data ?? false;

                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _buildButton(context,
                      text: "New Game",
                      backgroundColor: darkerTileColor,
                      onClick: () => isSaved
                          ? showDialog<void>(
                              context: context,
                              builder: (context) => SudokuDialog.confirmationDialog(
                                  context,
                                  text:
                                      "Are you sure you want to lose your progress and start the game all over again?",
                                  onConfirm: () => _showDifficultyDialog(context)))
                          : _showDifficultyDialog(context)),
                  SizedBox(height: 16),
                  if (isSaved)
                    _buildButton(context,
                        text: "Continute",
                        backgroundColor: lighterTileColor,
                        onClick: () => io
                            .load()
                            .then((snapshot) => _navigateToNewGame(context, snapshot)))
                ]);
              },
            ),
            SizedBox(height: 128),
          ],
        ),
      ),
    );
  }

  void _navigateToNewGame(BuildContext context, SudokuSnapshot snapshot,
      {bool pop = false}) {
    final navigator = Navigator.of(context);

    if (pop) navigator.pop();
    navigator.push(MaterialPageRoute(
      builder: (_) => SudokuPage(snapshot: snapshot),
    ));
  }

  Widget _buildButton(BuildContext context,
      {String text, Color backgroundColor, Function onClick}) {
    return SizedBox(
      width: 240,
      height: 40,
      child: RaisedButton(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        onPressed: onClick,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Future<void> _showDifficultyDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Center(
            child: Text(
              "Select difficulty",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          titlePadding: EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 16),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text("Easy"),
                  onPressed: () => _navigateToNewGame(
                      context, SudokuSnapshot(board: generateBoard(40)),
                      pop: true),
                ),
                RaisedButton(
                  color: Colors.amber,
                  child: Text("Medium"),
                  onPressed: () => _navigateToNewGame(
                      context, SudokuSnapshot(board: generateBoard(34)),
                      pop: true),
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text("Hard"),
                  onPressed: () => _navigateToNewGame(
                      context, SudokuSnapshot(board: generateBoard(26)),
                      pop: true),
                ),
                // Button for debuging end of the game, generating board with only 1 field needed
                if (!kReleaseMode)
                  RaisedButton(
                    color: Colors.black,
                    child: Text("Debug"),
                    onPressed: () => _navigateToNewGame(
                        context, SudokuSnapshot(board: generateBoard(80)),
                        pop: true),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
