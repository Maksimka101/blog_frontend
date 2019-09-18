import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  RoundedCard({
    this.child,
    this.radius = 10,
    this.color = const Color(0xFFF6F6F6),
  });
  final Widget child;
  final double radius;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: child,
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}
