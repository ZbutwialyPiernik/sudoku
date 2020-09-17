import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _focusNode = FocusNode();
  int selectedNumber;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: false,
      onKey: (key) {
        if (key is RawKeyUpEvent) {
          return;
        }

        final number = int.tryParse(key.data.keyLabel);

        if (number != null) {
          selectNumber(number);
        }
      },
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
    setState(() => selectedNumber = selectedNumber == value ? null : value);
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
        onPressed: () => selectNumber(value),
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
