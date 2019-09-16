import 'package:blog_frontend/model/serializable.dart';

enum Status {
  Ok,
  Error,
}

class Response<T extends Serializable> {
  Response({this.responseMessage, this.status, this.body, this.typedBody});

  Response.fromJson(Map<String, dynamic> response, {this.typedBody})
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
