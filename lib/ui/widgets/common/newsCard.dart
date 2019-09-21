import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatefulWidget {
  NewsCard({this.scrollPosition, this.post});
  final UiPostEntity post;
  final Stream<double> scrollPosition;
  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            _NewsCardTitle(title: widget.post.title),
            _NewsCardContentText(text: widget.post.content),
            _NewsCardContentImage(imageUrl: widget.post.imageUrl),
            _NewsCardComment(comments: widget.post.comments.length)
          ],
        ),
      ),
    );
  }
}

class _NewsCardTitle extends StatelessWidget {
  _NewsCardTitle({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), textAlign: TextAlign.center,);
  }
}

class _NewsCardContentText extends StatelessWidget {
  _NewsCardContentText({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(), overflow: TextOverflow.ellipsis,);
  }
}

class _NewsCardContentImage extends StatelessWidget {
  _NewsCardContentImage({this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
    );
  }
}

class _NewsCardComment extends StatelessWidget {
  _NewsCardComment({this.comments});
  final int comments;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.comment),
        Text(comments.toString()),
        Text('комментарев(я)')
      ],
    );
  }
}

