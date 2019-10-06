import 'package:blog_frontend/utils/stringUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({this.name, this.imageUrl, this.onClickOnImage});

  final String imageUrl;
  final String name;
  final void Function() onClickOnImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: InkWell(
              onTap: onClickOnImage,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.1,
                backgroundImage: CachedNetworkImageProvider(imageUrl),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                startToUpper(name),
                maxLines: 1,
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
