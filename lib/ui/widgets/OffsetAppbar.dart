import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OffsetAppBar extends AppBar {

  ///
  /// AppBar, который смещен на Offset.
  /// При этом child остается на месте. Смещается только фон.
  ///
  OffsetAppBar(
      {Widget child,
      Offset offset = const Offset(-30, 0),
      Color backgroundColor = const Color.fromARGB(255, 120, 0, 80)})
      : super(
          title: Transform.translate(
            offset: offset,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 7),
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(13)),
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 4)
                        ]),
                    child: Center(
                      child: Transform.translate(
                        child: child,
                        offset: Offset(-offset.dx, offset.dy),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        );
}
