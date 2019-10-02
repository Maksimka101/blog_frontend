import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  RoundedCard({
    this.child,
    this.radius = 10,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.color = const Color(0xFFF6F6F6),
  });
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget child;
  final double radius;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        child: Padding(
          padding: margin,
          child: child,
        ),
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius))),
      ),
    );
  }
}
