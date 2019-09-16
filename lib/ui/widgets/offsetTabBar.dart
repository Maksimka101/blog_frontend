import 'package:flutter/material.dart';

class OffsetTabBar extends StatelessWidget implements PreferredSize {
  OffsetTabBar({
    @required this.tabs,
    @required this.controller,
    @required this.backgroundColor,
    this.offset = const Offset(45, 0),
  });

  final Color backgroundColor;
  final List<Widget> tabs;
  final Offset offset;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Widget get child => Transform.translate(
        offset: offset,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
              color: backgroundColor),
          child: TabBar(
            controller: controller,
            tabs: tabs,
          ),
        ),
      );

  @override
  Size get preferredSize => TabBar(tabs: tabs).preferredSize;
}
