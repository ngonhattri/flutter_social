import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_social/constants/constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadProfilePicture(String url, File imageFile) async {
    String uniquePhotoId = const Uuid().v4();
    File? image = await compressImage(uniquePhotoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp('/((?:.(?!/))+\$)');
      uniquePhotoId = exp.firstMatch(url)?[1] as String;
    }
    UploadTask uploadTask = storageRef
        .child('images/users/userProfile/$uniquePhotoId')
        .putFile(image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadCoverPicture(String url, File imageFile) async {
    String uniquePhotoId = const Uuid().v4();
    File? image = await compressImage(uniquePhotoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp('/((?:.(?!/))+\$)');
      uniquePhotoId = exp.firstMatch(url)![1] as String;
    }
    UploadTask uploadTask = storageRef
        .child('images/users/userCover/$uniquePhotoId.jpg')
        .putFile(image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadPostPicture(File imageFile) async {
    String uniquePhotoId = const Uuid().v4();
    File? image = await compressImage(uniquePhotoId, imageFile);

    UploadTask uploadTask = storageRef
        .child('images/posts/post_$uniquePhotoId.jpg')
        .putFile(image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File?> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImage;
  }
}
