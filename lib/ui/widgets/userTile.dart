import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  UserTile(
      {@required this.userName,
      @required this.imageUrl,
      this.button,
      this.onClick});

  final String imageUrl;
  final String userName;
  final void Function() onClick;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: onClick ?? () {},
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(userName),
            if (button != null) button,
          ],
        ),
      ),
    );
  }
}
