import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InternalRepository {

  // client mean user
  // i just don't know how to name it
  InternalRepositoryClient get client => InternalRepositoryClient.instance;
  set client(InternalRepositoryClient client) => _updateClient(client);
  final storage = FlutterSecureStorage();

  Future<void> loadClient() async {
    InternalRepositoryClient(password: await storage.read(key: 'password'), name: await storage.read(key: 'uuid'));
  }

  void _updateClient(InternalRepositoryClient repositoryClient) {
    storage.write(key: 'password', value: repositoryClient.password);
    storage.write(key: 'uuid', value: repositoryClient.name);
  }

}
