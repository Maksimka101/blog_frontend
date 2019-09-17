import 'package:blog_frontend/model/serializable.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';

class UserUiEntity implements Serializable {
  String name;
  String imageUrl;
  final posts = <UiPostEntity>[];

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
