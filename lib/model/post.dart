import 'package:blog_frontend/model/Serializable.dart';

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
    imageUrl = json['image_url'];
    createDate = DateTime.parse(json['crate_date']);
  }

  int id;
  String authorId;
  String title;
  String content;
  String imageUrl;
  DateTime createDate;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author': authorId,
      'create_date': createDate.toString(),
    };
  }
}
