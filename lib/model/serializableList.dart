import 'package:blog_frontend/model/Serializable.dart';
import 'package:flutter/material.dart';

class SerializableList<T extends Serializable> implements Serializable{
  SerializableList({@required this.list});

  final List<T> list;

  @override
  void fromJson(dynamic json) {
    for (int i = 0; i < list.length; i++) {
      list[i].fromJson(json[i]);
    }
  }

  @override
  List<T> toJson() {
    return list.map((element) => element.toJson()).toList();
  }

}