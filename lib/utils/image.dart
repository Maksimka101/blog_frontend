import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

/// return bytes in list of int
Future<List<int>> compressImageFromBytesInCompute(Uint8List bytes) async {
  return await compute(_compressImageFromBytesSink, bytes);
}

List<int> _compressImageFromBytesSink(Uint8List bytes) {
  final image = decodeImage(bytes);
  Image resizedImage = image;
  if (image.height < image.width && image.height > 1920) {
    resizedImage = copyResize(image, height: 1920);
  } else if (image.width< image.height && image.width >1080) {
    resizedImage = copyResize(image, width: 1080);
  }
  final jpg = encodeJpg(resizedImage, quality: 90);
  return jpg;
}