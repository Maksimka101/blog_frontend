import 'package:blog_frontend/model/serializable.dart';

class User implements Serializable {
  User({this.name, this.imageUrl});

  String name;
  String imageUrl;
  List<String> subscriptions;

  void fromJson(dynamic json) {
    name = json['name'];
    imageUrl = json['image_url'];
    subscriptions = json['subscribes'].cast<String>().toList();
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['name'] = name;
    if (imageUrl != null) json['image_url'] = imageUrl;
    return json;
  }
}
