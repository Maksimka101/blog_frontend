import 'package:blog_frontend/model/comment.dart';

class UiPostEntity {
  String title;
  String content;
  String imageUrl;
  DateTime createDate;
  List<Comment> comments = <Comment>[];

  void fromJson(json) {
    title = json['title'];
    content = json['content'];
    imageUrl = json['image_url'];
    createDate = DateTime.parse(json['crate_date']);
    for (final comment in json['comments'])
      comments.add(Comment()..fromJson(comment));
  }
}
