import 'package:blog_frontend/model/Serializable.dart';
import 'package:flutter/material.dart';

enum Status {
  Ok,
  Error,
}

class Response <T extends Serializable> {
  Response.fromJson(Map<String, dynamic> response, {@required this.typedBody})
      : this.status = statusFromStr(response['status']),
        this.responseMessage = response['response_message'] ?? "",
        this.body = response['body'] {
    if (body != null) {
      typedBody.fromJson(body);
    }
  }

  String responseMessage;
  Status status;
  dynamic body;
  // Имеется в виду десериализованный body, например с User
  T typedBody;

  static Status statusFromStr(String status) {
    if (status == "OK") return Status.Ok;
    return Status.Error;
  }
}
