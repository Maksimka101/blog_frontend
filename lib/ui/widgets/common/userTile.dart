import 'package:blog_frontend/utils/stringUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  UserTile({this.userName = '', this.imageUrl, this.button, this.onClick});

  final String imageUrl;
  final String userName;
  final void Function() onClick;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        onTap: onClick ?? () {},
        child: Row(
          children: <Widget>[
            if (imageUrl != null)
              CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(imageUrl)),
            if (imageUrl == null)
              CircleAvatar(
                  child: Text(
                    userName.length > 0 ? userName[0].toUpperCase() : '',
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
                  )),
            SizedBox(width: 20),
            Flexible(
              child: button != null
                  ? Row(
                      children: <Widget>[
                        Text(
                          startToUpper(userName),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  : Text(
                      startToUpper(userName),
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (button != null) button,
          ],
        ),
      ),
    );
  }
}
