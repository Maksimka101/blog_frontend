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
    final List<String> dateTime = json['create_date'].split(' ');
    final List<String> date = dateTime[0].split('-');
    final List<String> minutes = dateTime[1].split('+')[0].split(':');
    createDate = DateTime.utc(
        int.parse(date[0]),
        int.parse(date[1]),
        int.parse(date[2]),
        int.parse(minutes[0]),
        int.parse(minutes[1]),
        int.parse(minutes[2]));
    for (final comment in json['comments'])
      comments.add(Comment()..fromJson(comment));
  }
}
