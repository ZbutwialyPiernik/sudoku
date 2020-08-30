import 'package:flutter/material.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/model/sudoku_io.dart';
import 'package:sudoku/view/cell_widget.dart';
import 'package:sudoku/model/sudoku_bloc.dart';
import 'package:sudoku/model/sudoku_snapshot.dart';
import 'package:sudoku/view/selection_page.dart';
import 'package:sudoku/view/settings_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tableSize = size.width < size.height ? size.width : size.height;

    final cellSize = tableSize / 9;

    return StreamBuilder<GameState>(
        stream: bloc.gameState,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is GameEnded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showConfirmationDialog(context, snapshot.data);
            });
          }

          return Scaffold(
            appBar: AppBar(
              brightness: Theme.of(context).brightness,
              shadowColor: Colors.transparent,
              backgroundColor: backgroundColor,
              automaticallyImplyLeading: true,
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
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => SettingsPage(
                        sudokuBloc: bloc,
                      ),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: backgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: tableSize,
                  height: tableSize,
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
                                        !cell.isEmpty && cell.value == selectedNumber,
                                    size: cellSize,
                                    stream: bloc.cell(Vector2D(x, y)),
                                    onTap: (cell) {
                                      if (!cell.isSolid && selectedNumber != null) {
                                        bloc.updateCell(Vector2D(x, y), selectedNumber);
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
                  children: [Container()],
                )
              ],
            ),
          );
        });
  }

  Future<void> _showConfirmationDialog(BuildContext context, GameEnded gameEnded) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Congratulations you finished in ${durationToString(gameEnded.gameTime)}"),
              ],
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () {
                final navigator = Navigator.of(context);

                navigator.pop();
                navigator.pop();
              },
              color: darkerTileColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  String durationToString(Duration duration) {
    return (duration.inMinutes % 60).toString() +
        ":" +
        (duration.inSeconds % 60).toString().padLeft(2, "0");
  }
}