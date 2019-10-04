import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:blog_frontend/utils/image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseRepository {
  /// return image Url
  static Future<String> saveImage(File file) async {
    if (file != null) {
      final imageBytes = file.readAsBytesSync();
      final compressedImageBytes = await compressImageFromBytesInCompute(
          imageBytes);
      file.writeAsBytesSync(compressedImageBytes);
      final storage = FirebaseStorage.instance;
      var ref = storage.ref();
      ref = ref.child('images/${Random().nextInt(4294967296)}.jpg');
      final result = await ref
          .putData(Uint8List.fromList(compressedImageBytes))
          .onComplete;
      return await result.ref.getDownloadURL();
    }
    else
      return null;
  }
}
