import 'dart:async';
import 'dart:convert';

import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/model/post.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/model/serializableList.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
import 'package:http/http.dart' as http;

class BackendRepository {
  static const example =
      '{"status": "OK", "body": [{"name": "some name", "image_url": "http://localhost:8000/admin/blog/user/add/",'
      '"subscribers": ["81e165a4-f363-4896-84bb-ea9a8e23eaad"], "subscribes": ["81e165a4-f363-4896-84bb-ea9a8e23eaad"], "id":'
      '"0f705993-9074-44de-89c2-06b4a57c1540", "posts": []}, {"name": "maksdim", "image_url":'
      '"http://localhost:8000/admin/blog/user/add/", "subscribers": [], "subscribes": [], "id":'
      '"3d32d456-132d-4920-85e5-f83b05161737", "posts": []}, {"name": "maksim", "image_url":'
      '"http://localhost:8000/admin/blog/user/add/", "subscribers": [], "subscribes": [], "id":'
      '"4d32d456-122d-4920-85e5-f93b05161737", "posts": []}, {"name": "maksim", "image_url":'
      '"http://localhost:8000/admin/blog/user/add/", "subscribers": [], "subscribes": [], "id":'
      '"4d32d456-122d-4920-87e5-f93b05161737", "posts": []}, {"name": "maksima", "image_url":'
      '"http://localhost:8000/admin/blog/user/add/", "subscribers": [], "subscribes": [], "id":'
      '"4d32d456-122d-4920-87e5-f93b0516173c", "posts": []}, {"name": "maksim", "image_url":'
      '"http://localhost:8000/admin/blog/user/add/", "subscribers": [], "subscribes": [], "id":'
      '"4d32d456-132d-4920-85e5-f83b05161737", "posts": []}]}';
  static const String BACKEND_URL = "http://vlog-backend.appspot.com";

  static Map<String, String> _headers() => {
        'password': InternalRepositoryUser.instance.password,
      };

  static Future<Response> registerUser(User user) async {
    Response response;
    try {
      final json = jsonEncode(user.toJson());
      final backendResponse = await http.post("$BACKEND_URL/blog/user/create",
          headers: _headers(), body: json);
      final decodedResponse = jsonDecode(backendResponse.body);
      response = Response.fromJson(decodedResponse);
    } catch (e) {
      response = Response(status: Status.Error);
    }
    return response;
  }

  static Future<Response<User>> getUser(String uuid) async {
    Response<User> response;
    try {
      final backendResponse =
          await http.get("$BACKEND_URL/blog/user/get/$uuid");
      if (backendResponse.statusCode != 200) {
        response = Response<User>(status: Status.Error);
      } else {
        final decodedResponse = jsonDecode(backendResponse.body);
        response = Response<User>.fromJson(decodedResponse, typedBody: User());
      }
    } catch (e) {
      print(e);
      response = Response<User>(status: Status.Error);
    }
    return response;
  }

  static Future<Response<RepositoryUserEntity>> getUserWithPosts(
      String uuid) async {
    Response<RepositoryUserEntity> response;
    try {
      final backendResponse =
          await http.get("$BACKEND_URL/blog/user/get_full/$uuid");
      final decodedResponse = jsonDecode(backendResponse.body);
      response = Response<RepositoryUserEntity>.fromJson(decodedResponse,
          typedBody: RepositoryUserEntity());
    } catch (e) {
      print(e);
      response = Response<RepositoryUserEntity>(status: Status.Error);
    }
    return response;
  }

  static Future<Response<SerializableList<RepositoryUserEntity>>>
      getAllUserSubscription(String userName) async {
    Response<SerializableList<RepositoryUserEntity>> response;
    try {
      final backendResponse = await http
          .get('$BACKEND_URL/blog/user/get_all_subscriptions/$userName');
      final decodedResponse = jsonDecode(backendResponse.body);
      final listForDecode = decodedResponse['body']
          .map((_) => RepositoryUserEntity())
          .cast<RepositoryUserEntity>()
          .toList();
      response = Response<SerializableList<RepositoryUserEntity>>.fromJson(
          decodedResponse,
          typedBody:
              SerializableList<RepositoryUserEntity>(list: listForDecode));
    } catch (e) {
      print('exeptinon while load user with subscriptions');
      response = Response<SerializableList<RepositoryUserEntity>>(
          status: Status.Error);
    }
    return response;
  }

  static Future<Response> subscribeUser(
      String userId, String subscriberId) async {
    Response response;
    try {
      final request = await http.post(
          '$BACKEND_URL/blog/user/subscribe?user=$userId&subscriber=$subscriberId',
          headers: _headers());
      response = Response.fromJson(jsonDecode(request.body));
    } catch (e) {
      print(e);
      response = Response(status: Status.Error);
    }
    return response;
  }

  static Future<Response> unsubscribeUser(
      String userId, String subscriberId) async {
    Response response;
    try {
      final request = await http.post(
          '$BACKEND_URL/blog/user/unsubscribe?user=$userId&subscriber=$subscriberId',
          headers: _headers());
      response = Response.fromJson(jsonDecode(request.body));
    } catch (e) {
      print(e);
      response = Response(status: Status.Error);
    }
    return response;
  }

  static Future<Response<SerializableList<User>>> getUsersByName(
      String name) async {
    Response<SerializableList<User>> response;
    try {
      final request =
          await http.get('$BACKEND_URL/blog/user/find_by_name/$name');
      if (request.statusCode != 200)
        response = Response<SerializableList<User>>(status: Status.Error);
      else {
        final decodedRequest = jsonDecode(request.body);
        response = Response<SerializableList<User>>.fromJson(decodedRequest,
            typedBody: SerializableList(
                list: decodedRequest['body']
                    .map((_) => User())
                    .cast<User>()
                    .toList()));
      }
    } catch (e) {
      print(e);
      response = Response<SerializableList<User>>(status: Status.Error);
    }
    return response;
  }

  static Future<Response> updatePost(Post post) async => await createPost(post);

  static Future<Response> createPost(Post post) async {
    Response response;
    try {
      final jsonPost = jsonEncode(post.toJson());
      final request = await http.post('$BACKEND_URL/blog/create_post',
          headers: _headers(), body: jsonPost);
      response = Response.fromJson(jsonDecode(request.body));
    } catch (e) {
      print(e);
      response = Response(status: Status.Error);
    }
    return response;
  }

  static Future<Response> deletePost(int postId) async {
    Response response;
    try {
      final request = await http.delete(
          '$BACKEND_URL/blog/user/delete_post/$postId',
          headers: _headers());
      response = Response.fromJson(jsonDecode(request.body), typedBody: null);
    } catch (e) {
      print(e);
      response = Response(status: Status.Error);
    }
    return response;
  }

  static Future<Response> createComment(Comment comment) async {
    comment.authorId = InternalRepositoryUser.instance.name;
    Response response;
    try {
      final request = await http.post('$BACKEND_URL/blog/user/comment/create',
          headers: _headers(), body: jsonEncode(comment.toJson()));

      if (request.statusCode != 200)
        response = Response(status: Status.Error);
      else
        response = Response.fromJson(jsonDecode(request.body), typedBody: null);
    } catch (e) {
      print(e);
      response = Response(
          status: Status.Error,
          responseMessage:
              'Ошибка на сервере. Возможно нет интернета или прав доступа.');
    }
    return response;
  }

  static Future<Response> deleteComment(String commentId) async {
    Response response;
    try {
      final request = await http.post(
          '$BACKEND_URL/blog/comment/delete/$commentId',
          headers: _headers());
      response = Response.fromJson(jsonDecode(request.body), typedBody: null);
    } catch (e) {
      print(e);
      response = Response(status: Status.Error);
    }
    return response;
  }
}
