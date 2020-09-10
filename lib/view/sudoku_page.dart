import 'package:flutter/material.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/view/cell_widget.dart';
import 'package:sudoku/model/sudoku_bloc.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';
import 'package:sudoku/view/selection_page.dart';
import 'package:sudoku/view/sudoku_dialog.dart';
import 'package:sudoku/view/sudoku_keyboard.dart';

final Color backgroundColor = Color.fromARGB(255, 26, 27, 67);
final Color lighterTileColor = Color.fromARGB(255, 95, 97, 187);
final Color darkerTileColor = Color.fromARGB(255, 66, 67, 146);
final Color selectionColor = Color.fromARGB(255, 255, 176, 144);

class SudokuPage extends StatefulWidget {
  final SudokuSnapshot snapshot;

  SudokuPage({Key key, @required this.snapshot})
      : assert(snapshot != null),
        super(key: key);

  @override
  _SudokuPageState createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  bool tipMode = false;
  int selectedNumber;
  SudokuBloc bloc = SudokuBloc();

  @override
  void initState() {
    super.initState();

    bloc.load(widget.snapshot);
    bloc.resume();
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  double _determineBoardWidth(Size screenSize) {
    return screenSize.width < screenSize.height
        ? screenSize.width.clamp(0, screenSize.height * 0.7)
        : screenSize.height * 0.7;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boardSize = _determineBoardWidth(size);

    final cellSize = boardSize / 9;

    return StreamBuilder<GameState>(
        stream: bloc.gameState,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is GameEnded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showGameFinishedDialog(context, snapshot.data);
            });
          }

          return Scaffold(
            appBar: AppBar(
              brightness: Theme.of(context).brightness,
              backgroundColor: darkerTileColor,
              title: StreamBuilder<Duration>(
                  stream: bloc.currentTime,
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text(durationToString(snapshot.data),
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.w400))
                      : Container()),
              centerTitle: true,
              leading: BackButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SelectionPage()))),
            ),
            backgroundColor: backgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: boardSize,
                  height: boardSize,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          for (var y = 0; y < 9; y++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var x = 0; x < 9; x++)
                                  CellWidget(
                                    padding: EdgeInsets.only(
                                        left: 2, right: 2, top: 2, bottom: 2),
                                    isHighlighted: (cell) =>
                                        (!cell.isEmpty && cell.value == selectedNumber) || (cell.hasTips && cell.tips.contains(selectedNumber)),
                                    size: cellSize,
                                    stream: bloc.cell(Vector2D(x, y)),
                                    onTap: (cell) {
                                      if (selectedNumber != null && !cell.isSolid) {
                                        if (tipMode) {
                                          bloc.updateCellWithTip(
                                              Vector2D(x, y), selectedNumber);
                                        } else {
                                          bloc.updateCellWithValue(
                                              Vector2D(x, y), selectedNumber);
                                        }
                                      }
                                    },
                                  )
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SudokuKeyboard(
                  onNumberSelect: (number) => setState(() => selectedNumber = number),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      icon: Icon(
                        Icons.edit,
                        color: tipMode
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).disabledColor,
                      ),
                      onPressed: () => setState(() => tipMode = !tipMode),
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      onPressed: null,
                      icon: Icon(Icons.undo),
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      onPressed: null,
                      icon: Icon(Icons.redo),
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      onPressed: () => showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => SudokuDialog.confirmationDialog(context,
                            text: "Are you sure that you want to restart the game?",
                            onConfirm: () => bloc.reset()),
                      ),
                      icon: Icon(Icons.refresh),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _showGameFinishedDialog(BuildContext context, GameEnded gameEnded) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => SudokuDialog.showDialog(context,
          text:
              "Congratulations, you finished game in ${durationToString(gameEnded.gameTime)}",
          actions: [
            RaisedButton(
              onPressed: () {
                final navigator = Navigator.of(context);

                navigator..pop()..pop();
              },
              color: darkerTileColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Text("Continue"),
            ),
          ]),
    );
  }

  String durationToString(Duration duration) {
    return (duration.inMinutes % 60).toString() +
        ":" +
        (duration.inSeconds % 60).toString().padLeft(2, "0");
  }
}
