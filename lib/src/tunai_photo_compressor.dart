// change mb to kb with proper name

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class PhotoCompressor {
  static Future<File> compress({
    required File file,
    required double maxSizeInKB,
    int maxAttempt = 10,
  }) async {
    double fileSize = file.lengthSync() / 1024.0;

    int attempt = 0;
    int quality = 70;

    while (fileSize > maxSizeInKB && attempt < maxAttempt) {
      var imageBytes = await file.readAsBytes();
      List<int> compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 1000,
        minWidth: 1000,
        quality: quality,
      );

      File tempFile = await file.writeAsBytes(compressedBytes);
      fileSize = await tempFile.length() / 1024;

      if (fileSize <= maxSizeInKB) {
        return tempFile;
      }

      file = tempFile;
      quality -= 5;
      attempt++;
    }

    return file;
  }
}
