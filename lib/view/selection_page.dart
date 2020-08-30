import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/model/sudoku_io.dart';
import 'package:sudoku/model/sudoku_generator.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';

import 'package:sudoku/view/sudoku_page.dart';

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  int difficulty;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createDifficultyRadio("EASY", 48),
                _createDifficultyRadio("MEDIUM", 32),
                _createDifficultyRadio("HARD", 24),
              ],
            ),
            FutureBuilder<bool>(
              future: io.isSaved(),
              builder: (context, snapshot) {
                final isSaved = snapshot.data ?? false;

                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _buildButton(context, "New Game", () {
                    if (isSaved)
                      _showConfirmationDialog(
                        context,
                        "Are you sure you want to lose your progress and start the game all over again?",
                        [
                          FlatButton(
                              child: Text(
                                'Yes',
                                style: Theme.of(context).textTheme.button.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showDifficultyDialog();
                              }),
                          FlatButton(
                              child: Text(
                                'No',
                                style: Theme.of(context).textTheme.button.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18),
                              ),
                              onPressed: () => Navigator.of(context).pop())
                        ],
                      );
                    else {
                      Navigator.of(context).pop();
                      _showDifficultyDialog();
                    }
                  }),
                  if (isSaved)
                    _buildButton(context, "Continute", () async {
                      final snapshot = await io.load();
                      _navigateToNewGame(snapshot);
                    })
                ]);
              },
            ),
            SizedBox(height: 128),
          ],
        ),
      ),
    );
  }

  Widget _createDifficultyRadio(String text, int difficulty) {
    return Column(
      children: [
        Text(text),
        Radio(
            value: 32,
            groupValue: null,
            onChanged: (value) => setState(() => difficulty = value)),
      ],
    );
  }

  void _navigateToNewGame(SudokuSnapshot snapshot, {bool pop = false}) {
    final navigator = Navigator.of(context);

    if (pop) navigator.pop();
    navigator
        .push(MaterialPageRoute(
          builder: (_) => SudokuPage(snapshot: snapshot),
        ))
        .then((value) => setState(() {}));
    // Page needs to get refreshed, because game save will be either
    // deleted (after finished game) or created new one after leaving page with unfinished game
  }

  Widget _buildButton(BuildContext context, String text, Function onClick) {
    return SizedBox(
      width: 240, // specific value
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        onPressed: onClick,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.button.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Future<void> _showDifficultyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
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
                      SudokuSnapshot(board: generateBoard(48)),
                      pop: true),
                ),
                RaisedButton(
                  color: Colors.amber,
                  child: Text("Medium"),
                  onPressed: () => _navigateToNewGame(
                      SudokuSnapshot(board: generateBoard(32)),
                      pop: true),
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text("Hard"),
                  onPressed: () => _navigateToNewGame(
                      SudokuSnapshot(board: generateBoard(24)),
                      pop: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, String body, List<Widget> actions) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  body,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
          ),
          actions: actions,
        );
      },
    );
  }
}
