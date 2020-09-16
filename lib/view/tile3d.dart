import 'package:flutter/material.dart';

// Author: https://github.com/nguyenvanduocit/button3d
// Modified for my purpose
class Tile3dStyle {
  final Color topColor;
  final Color backColor;
  final BorderRadius borderRadius;
  final double z;
  final double tappedZ;
  const Tile3dStyle({
    this.topColor = const Color(0xFF45484c),
    this.backColor = const Color(0xFF191a1c),
    this.borderRadius = const BorderRadius.all(Radius.circular(2.0)),
    this.z = 3.0,
    this.tappedZ = 3.0,
  });
}

class Tile3d extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Tile3dStyle style;
  final double width;
  final double height;

  Tile3d({
    @required this.onPressed,
    @required this.child,
    this.style = const Tile3dStyle(),
    this.width = 100.0,
    this.height = 90.0,
  });

  @override
  State<StatefulWidget> createState() => Tile3dState();
}

class Tile3dState extends State<Tile3d> {
  bool isTapped = false;

  Widget _buildBackLayout() {
    return Padding(
      padding: EdgeInsets.only(top: widget.style.z),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
            borderRadius: widget.style.borderRadius,
            boxShadow: [BoxShadow(color: widget.style.backColor)]),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: widget.width, height: widget.height - widget.style.z),
        ),
      ),
    );
  }

  Widget _buildTopLayout() {
    return Padding(
      padding:
          EdgeInsets.only(top: isTapped ? widget.style.z - widget.style.tappedZ : 0.0),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
            borderRadius: widget.style.borderRadius,
            boxShadow: [BoxShadow(color: widget.style.topColor)]),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: widget.width, height: widget.height - widget.style.z),
          child: Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.onPressed != null
        ? GestureDetector(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[_buildBackLayout(), _buildTopLayout()],
            ),
            onTapDown: (TapDownDetails event) {
              setState(() {
                isTapped = true;
              });
            },
            onTapCancel: () {
              setState(() {
                isTapped = false;
              });
            },
            onTapUp: (TapUpDetails event) {
              setState(() {
                isTapped = false;
              });
              widget?.onPressed();
            },
          )
        : Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[_buildBackLayout(), _buildTopLayout()],
          );
  }
}
