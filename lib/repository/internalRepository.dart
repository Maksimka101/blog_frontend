import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InternalRepository {
  // client mean user
  // i just don't know how to name it
  InternalRepositoryUser get user => InternalRepositoryUser.instance;
  set user(InternalRepositoryUser user) => _updateClient(user);
  final storage = FlutterSecureStorage();

  Future<void> loadClient() async {
    InternalRepositoryUser(
        isAnonymous: await storage.read(key: 'anonymous') == null,
        password: await storage.read(key: 'password'),
        name: await storage.read(key: 'uuid'));
  }

  void _updateClient(InternalRepositoryUser repositoryUser) {
    storage.write(key: 'password', value: repositoryUser.password);
    storage.write(key: 'uuid', value: repositoryUser.name);
  }
}
