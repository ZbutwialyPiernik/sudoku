import 'package:flutter/material.dart';
import 'package:sudoku/model/cell.dart';
import 'package:sudoku/view/color_util.dart';
import 'package:sudoku/view/sudoku_page.dart';
import 'package:sudoku/view/tile3d.dart';

class CellWidget extends StatefulWidget {
  final Stream<Cell> stream;

  final double size;
  final EdgeInsets padding;

  final bool Function(Cell) isHighlighted;
  final Function(Cell) onTap;

  const CellWidget({
    Key key,
    @required this.size,
    @required this.onTap,
    @required this.stream,
    @required this.isHighlighted,
    this.padding: EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Cell>(
      stream: widget.stream,
      builder: (context, snapshot) {
        final cell = snapshot.data;

        if (!snapshot.hasData) {
          return Container();
        }

        final backgroundColor = _determineColor(cell);

        return Tile3d(
          width: widget.size - widget.padding.left - widget.padding.right,
          height: widget.size - widget.padding.top - widget.padding.bottom,
          style:
              Tile3dStyle(topColor: backgroundColor, backColor: darken(backgroundColor)),
          onPressed: cell.isSolid ? null : () => widget.onTap(cell),
          child: Center(
            child: Text(
              cell.isEmpty ? "" : cell.value.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: cell.isSolid ? FontWeight.w500 : FontWeight.w300,
              ), //cell.isSolid ? FontWeight.w700 : FontWeight.w300),
            ),
          ),
        );
      },
    );
  }

  Color _determineColor(Cell cell) {
    if (widget.isHighlighted(cell)) {
      return selectionColor;
    }

    final x = cell.position.x ~/ 3;
    final y = cell.position.y ~/ 3;

    if ((x == 0 || x == 2) && (y == 0 || y == 2) || (x == 1 && y == 1)) {
      return lighterTileColor;
    } else {
      return darkerTileColor;
    }
  }
}
