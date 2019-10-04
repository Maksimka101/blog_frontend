import 'package:blog_frontend/model/serializable.dart';

class Post implements Serializable {
  Post(
      {this.id,
      this.content,
      this.title,
      this.imageUrl,
      this.createDate,
      this.authorId});

  void fromJson(dynamic json) {
    id = json['id'];
    authorId = json['author'];
    title = json['title'];
    content = json['content'];
    imageUrl = json['image_url'];final List<String> dateTime = json['create_date'].split(' ');
    final List<String> date = dateTime[0].split('-');
    final List<String> minutes = dateTime[1].split('+')[0].split(':');
    createDate = DateTime.utc(
        int.parse(date[0]),
        int.parse(date[1]),
        int.parse(date[2]),
        int.parse(minutes[0]),
        int.parse(minutes[1]),
        int.parse(minutes[2]));
  }

  int id;
  String authorId;
  String title;
  String content;
  String imageUrl;
  DateTime createDate;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author': authorId,
    };
    if (id != null) json['id'] = id;
    if (createDate != null) json['create_date'] = createDate.toString();
    return json;
  }
}
