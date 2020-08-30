import 'package:flutter/material.dart';
import 'package:sudoku/model/sudoku_bloc.dart';

class SettingsPage extends StatefulWidget {
  final SudokuBloc sudokuBloc;

  const SettingsPage({Key key, @required this.sudokuBloc})
      : assert(sudokuBloc != null),
        super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => Navigator.of(context).pop(),
      child: Material(
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: true,
              onChanged: (_) {},
            ),
            RaisedButton.icon(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              onPressed: () {
                widget.sudokuBloc.reset();
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              icon: Icon(Icons.refresh),
              label: Text("RESET"),
            )
          ],
        ),
      ),
    );
  }
}
