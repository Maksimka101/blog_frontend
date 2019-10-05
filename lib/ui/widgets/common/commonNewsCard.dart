import 'dart:io';

import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// You can give an image url or image file.
class CommonNewsCard extends StatelessWidget {
  CommonNewsCard({
    this.title,
    this.content,
    this.imageUrl,
    this.commentsCount,
    this.isExpanded,
    this.image,
  });

  final bool isExpanded;
  final File image;
  final String title;
  final String content;
  final String imageUrl;
  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      margin: const EdgeInsets.only(top: 8, bottom: 4, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          _NewsCardTitle(title: title),
          _NewsCardContentText(text: content, isExpanded: isExpanded),
          _NewsCardContentImage(imageUrl: imageUrl, image: image),
          SizedBox(height: 4),
//              Divider(indent: 13, endIndent: 13, color: Colors.grey, height: 3),
          _NewsCardComment(comments: commentsCount)
        ],
      ),
    );
  }
}

class _NewsCardTitle extends StatelessWidget {
  _NewsCardTitle({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return title != null && title.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        title ?? '',
        style: Theme
            .of(context)
            .textTheme
            .title,
        textAlign: TextAlign.center,
      ),
    )
        : Container();
  }
}

class _NewsCardContentText extends StatelessWidget {
  _NewsCardContentText({this.text, this.isExpanded});
  final bool isExpanded;
  final String text;
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (text != null && text.isNotEmpty)
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          text,
          style: Theme
              .of(context)
              .textTheme
              .body1,
          overflow: TextOverflow.fade,
        ),
      );
    else
      content = Container();
    return !isExpanded
        ? Expanded(
            child: content,
          )
        : content;
  }
}

class _NewsCardContentImage extends StatelessWidget {
  _NewsCardContentImage({this.imageUrl, this.image});
  final File image;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: imageUrl != null || image != null
          ? (imageUrl != null
              ? CachedNetworkImage(
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                )
              : Image.file(
                  image,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ))
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
        child: Placeholder(
          color: Colors.blueGrey,
          strokeWidth: 3,
        ),
            ),
    );
  }
}

class _NewsCardComment extends StatelessWidget {
  _NewsCardComment({this.comments});
  final Color textColor = Colors.grey[600];
  final int comments;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.mode_comment,
          size: 19,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Text(
            comments.toString(),
            style: Theme
                .of(context)
                .textTheme
                .body1,
          ),
        ),
        Text(comments == 0 ? 'комментариев' : 'комментария',
            style: Theme
                .of(context)
                .textTheme
                .body1)
      ],
    );
  }
}
