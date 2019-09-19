import 'package:blog_frontend/model/serializable.dart';

class User implements Serializable {
  User(
      {this.name,
      this.imageUrl});

  void fromJson(dynamic json) {
    name = json['name'];
    imageUrl = json['image_url'];
  }
  String name;
  String imageUrl;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['name'] = name;
    if (imageUrl != null) json['image_url'] = imageUrl;
    return json;
  }
}
