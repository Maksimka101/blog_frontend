import 'package:flutter/material.dart';

class OffsetAppBar extends StatelessWidget implements PreferredSize {
  OffsetAppBar(
      {@required this.title,
      this.offset = const Offset(-45, 0),
      this.centerTitle = true,
      this.autoImplementLeading = false});

  final Widget title;
  final bool centerTitle;
  final Offset offset;
  final bool autoImplementLeading;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Widget get child => Transform.translate(
        offset: offset,
        child: Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(9))),
          child: AppBar(
            elevation: 30,
            leading: autoImplementLeading
                ? Transform.translate(
                    offset: Offset(-offset.dx, 0),
                    child: BackButton(),
                  )
                : Container(),
            title: Transform.translate(
              child: title,
              offset: Offset(-offset.dx, 0),
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20))),
            centerTitle: centerTitle,
          ),
        ),
      );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  ///
  /// AppBar, который смещен на Offset.
  /// При этом child остается на месте. Смещается только фон.
  ///
//  OffsetAppBar(
//      {Widget title,
//      Offset offset = const Offset(-30, 0),
//      Color backgroundColor = const Color.fromARGB(255, 120, 0, 80)})
//      : super(
//          title: Transform.translate(
//            offset: offset,
//            child: Flex(
//              direction: Axis.horizontal,
//              children: [
//                Expanded(
//                  child: Container(
//                    margin: EdgeInsets.only(bottom: 7),
//                    decoration: BoxDecoration(
//                        color: backgroundColor,
//                        borderRadius:
//                            BorderRadius.only(bottomRight: Radius.circular(13)),
//                        boxShadow: [
//                          BoxShadow(color: Colors.black, blurRadius: 4)
//                        ]),
//                    child: Center(
//                      child: Transform.translate(
//                        child: title,
//                        offset: Offset(-offset.dx, offset.dy),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          backgroundColor: Colors.transparent,
//          elevation: 0,
//          centerTitle: true,
//        );
}
