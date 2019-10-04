import 'package:flutter/material.dart';

class OffsetBottomNavigationBar extends StatefulWidget {
  OffsetBottomNavigationBar({
    this.backgroundColor,
    this.offset = const Offset(45, 0),
    @required this.controller,
    @required List<BottomNavigationBarItem> tabs,
  }) : this.tabs = tabs
          ..add(BottomNavigationBarItem(
              icon: Container(
                width: offset.dx,
              ),
              title: Container()));

  final Color backgroundColor;
  final List<BottomNavigationBarItem> tabs;
  final Offset offset;
  final TabController controller;

  @override
  _OffsetBottomNavigationBarState createState() =>
      _OffsetBottomNavigationBarState();
}

class _OffsetBottomNavigationBarState extends State<OffsetBottomNavigationBar> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void _onTabClick(int index) {
    if (index < widget.tabs.length - 1 && index != widget.controller.index)
      setState(() {
        widget.controller.animateTo(index);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.offset,
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(9)),
            color: widget.backgroundColor ?? AppBarTheme.of(context).color,
          ),
          child: BottomNavigationBar(
            elevation: 20,
            currentIndex: widget.controller.index,
            backgroundColor: Colors.transparent,
            onTap: _onTabClick,
            items: widget.tabs,
          ),
        ),
      ),
    );
  }
}

class OffsetBottomBar extends StatelessWidget {
  OffsetBottomBar(
      {this.offset = const Offset(45, 0),
      this.backgroundColor,
      List<Widget> child})
      : this.child = child ?? <Widget>[];

  final Offset offset;
  final Color backgroundColor;
  final List<Widget> child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      child: Container(
          height: kBottomNavigationBarHeight,
          decoration: BoxDecoration(
              color: backgroundColor ?? AppBarTheme.of(context).color,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(9))),
          child: Transform.translate(
            offset: Offset(-offset.dx, offset.dy),
            child: Row(mainAxisSize: MainAxisSize.min, children: child
//                ..insert(0, SizedBox(width: offset.dx,))
                ),
          )),
      offset: offset,
    );
  }
}
