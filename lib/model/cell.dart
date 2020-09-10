import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Vector2D extends Equatable {
  final int x;
  final int y;

  Vector2D(this.x, this.y);

  @override
  List<Object> get props => [x, y];

  @override
  bool get stringify => true;

  static Vector2D fromJson(Map<String, dynamic> json) {
    return Vector2D(json['x'] as int, json['y'] as int);
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };
}

class Cell extends Equatable {
  final Vector2D position;
  final int value;
  final bool isSolid;
  final List<int> tips;

  Cell._({
    @required this.position,
    @required this.value,
    this.isSolid = false,
    List<int> tips,
  })  : assert(position != null),
        assert(value != null),
        assert(tips == null || (tips.isNotEmpty && value == 0)),
        tips = tips != null ? List.unmodifiable(tips..sort()) : null;

  bool get isEmpty => value == 0;

  bool get hasTips => tips != null && tips.isNotEmpty;

  @override
  List<Object> get props => [position, value, isSolid, tips];

  @override
  bool get stringify => true;

  static Cell fromJson(Map<String, dynamic> json) {
    return Cell._(
      position: Vector2D.fromJson(json['position']),
      value: json['value'],
      isSolid: json['isSolid'],
      tips: json['tips'] as List<int>,
    );
  }

  Map<String, dynamic> toJson() => {
        'position': position.toJson(),
        'value': value,
        'isSolid': isSolid,
        'tips': tips,
      };

  static Cell empty(Vector2D position) => Cell._(position: position, value: 0);

  static Cell solid(Vector2D position, int value) =>
      Cell._(position: position, value: value, isSolid: true);

  static Cell normal(Vector2D position, int value) =>
      Cell._(position: position, value: value);

  static Cell withTips(Vector2D position, List<int> tips) =>
      Cell._(position: position, value: 0, tips: tips);
}
