import 'package:flutter/material.dart';

class WordMarker extends StatelessWidget {
  const WordMarker({
    Key key,
    @required this.rect,
    @required this.startIndex,
    this.color = Colors.yellow,
    this.width = 2.0,
    this.radius = 6.0,
  }) : super(key: key);

  final Rect rect;
  final Color color;
  final double width;
  final double radius;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: width,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  WordMarker copyWith({Rect rect}) {
    return WordMarker(
      key: key,
      rect: rect ?? this.rect,
      startIndex: startIndex,
      color: color,
      width: width,
      radius: radius,
    );
  }
}