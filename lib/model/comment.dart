import 'serializable.dart';

class Comment implements Serializable {

  Comment({this.authorId, this.content, this.authorImageUrl, this.postId});

  String authorId;
  String postId;
  String content;
  String authorImageUrl;

  @override
  void fromJson(dynamic json) {
    authorId = json['author'];
    postId = json['post'];
    content = json['content'];
    authorImageUrl = json['author_image_url'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'author': authorId,
      'post': postId,
      'content': content,
      'author_image_url': authorImageUrl,
    };
  }

}