import 'package:flutter/material.dart';
import 'package:sudoku/view/sudoku_page.dart';

class SudokuDialog {
  static AlertDialog confirmationDialog(
    BuildContext context, {
    String text,
    Function onConfirm,
    Function onCancel,
    barrierDismissible = true,
  }) =>
      showDialog(
        context,
        text: text,
        barrierDismissible: barrierDismissible,
        actions: [
          FlatButton(
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.red, fontWeight: FontWeight.w800, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              }),
          FlatButton(
              child: Text(
                'No',
                style: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
              ),
              onPressed: onCancel ?? () => Navigator.of(context).pop())
        ],
      );

  static AlertDialog showDialog(
    BuildContext context, {
    String text,
    List<Widget> actions,
    barrierDismissible = true,
  }) =>
      AlertDialog(
        backgroundColor: backgroundColor,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                text,
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
}
