import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InternalRepository {
  set user(InternalRepositoryUser user) => _updateClient(user);
  final storage = FlutterSecureStorage();

  Future<void> loadUser() async {
    final anon = await storage.read(key: 'anonymous');
    InternalRepositoryUser(
        isAnonymous: anon == 'true',
        password: await storage.read(key: 'password'),
        name: await storage.read(key: 'uuid'),
    imageUrl: await storage.read(key: 'imageUrl'));
  }

  void _updateClient(InternalRepositoryUser repositoryUser) {
    storage.write(key: 'password', value: repositoryUser.password);
    storage.write(key: 'uuid', value: repositoryUser.name);
    storage.write(key: 'anonymous', value: repositoryUser.isAnonymous.toString());
    storage.write(key: 'imageUrl', value: repositoryUser.imageUrl);
  }
}
