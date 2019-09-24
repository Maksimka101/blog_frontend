import 'package:blog_frontend/model/comment.dart';

class UiPostEntity {
  int id;
  String title;
  String content;
  String imageUrl;
  DateTime createDate;
  List<Comment> comments = <Comment>[];

  void fromJson(json) {
    title = json['title'];
    content = json['content'];
    id = json['id'];
    imageUrl = json['image_url'];
    final List<String> date = json['create_date'].split('-');
    createDate = DateTime.utc(
        int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
    for (final comment in json['comments'])
      comments.add(Comment()..fromJson(comment));
  }
}
