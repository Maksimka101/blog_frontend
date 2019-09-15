import 'package:blog_frontend/model/Serializable.dart';

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
    return {
      'name': name,
      'image_url': imageUrl,
    };
  }
}
