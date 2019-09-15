import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseRepository {
  /// return image Url
  static String saveUserImage(File image) {
    // todo
    final storageReference = FirebaseStorage().ref().child('path');
  }

  static File loadUserImage() {
    // todo
  }
}
