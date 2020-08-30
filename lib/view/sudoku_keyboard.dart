import 'package:flutter/material.dart';
import 'package:sudoku/view/color_util.dart';
import 'package:sudoku/view/sudoku_page.dart';
import 'package:sudoku/view/tile3d.dart';

class SudokuKeyboard extends StatefulWidget {
  final Function(int) onNumberSelect;

  const SudokuKeyboard({Key key, this.onNumberSelect}) : super(key: key);

  @override
  _SudokuKeyboardState createState() => _SudokuKeyboardState();
}

class _SudokuKeyboardState extends State<SudokuKeyboard> {
  FocusNode focusNode;
  int selectedNumber;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();

    focusNode?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: false,
      onKey: (key) {
        final number = int.tryParse(key.character);

        if (number != null) {
          selectNumber(number);
        }
      },
      focusNode: focusNode,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (var i = 1; i <= 5; i++) _buildButton(i.toString(), i)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 6; i <= 9; i++) _buildButton(i.toString(), i),
              _buildButton("X", 0)
            ],
          ),
        ],
      ),
    );
  }

  void selectNumber(int value) {
    setState(() => selectedNumber = value);
    widget.onNumberSelect(value);
  }

  Widget _buildButton(String text, int value) {
    final bool selected = value == selectedNumber;
    final backgroundColor = selected ? selectionColor : darkerTileColor;

    return Padding(
      padding: EdgeInsets.all(4),
      child: Tile3d(
        width: 56,
        height: 56,
        style: Tile3dStyle(
          z: 8,
          borderRadius: BorderRadius.circular(8),
          topColor: backgroundColor,
          backColor: darken(backgroundColor, 0.2),
        ),
        onPressed: () {
          if (selectedNumber == value) {
            selectNumber(null);
          } else {
            selectNumber(value);
          }
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
