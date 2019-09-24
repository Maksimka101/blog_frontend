import 'serializable.dart';

class Comment implements Serializable {

  Comment({this.authorId, this.content, this.authorImageUrl, this.postId, this.id});

  String authorId;
  int id;
  int postId;
  String content;
  String authorImageUrl;

  @override
  void fromJson(dynamic json) {
    authorId = json['author'];
    postId = json['post'];
    content = json['content'];
    authorImageUrl = json['author_image_url'];
    id = json['id'];
  }

  @override
  Map<String, dynamic> toJson() {
    final json = {
      'author': authorId,
      'post': postId,
      'content': content
    };
    if (id != null)
      json['id'] = id;
    return json;
  }

}