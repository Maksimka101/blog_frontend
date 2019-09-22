import 'package:blog_frontend/model/serializable.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';

class RepositoryUserEntity implements Serializable {
  String name;
  String imageUrl;
  final List<UiPostEntity> posts = [];

  @override
  void fromJson(json) {
    name = json['name'];
    imageUrl = json['image_url'];
    for (final post in json['posts']) {
      posts.add(UiPostEntity()..fromJson(post));
    }
  }

  @override
  toJson() {
    return null;
  }
}
