import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:blog_frontend/utils/stringUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  CommentTile({this.imageUrl, this.content, this.authorName});

  final String content;
  final String authorName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (imageUrl != null)
              CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(imageUrl)),
            if (imageUrl == null)
              CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    authorName.length > 0 ? authorName[0].toUpperCase() : '',
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
                  )),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    startToUpper(authorName),
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColorLight,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    content,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
