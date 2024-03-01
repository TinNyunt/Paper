import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WallpaperPost {
  final User? auth = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> PostWallpaper(
      String title, File image, String description, String categoryList) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var storageRef = storage
        .ref()
        .child('Wallpaper/${auth?.email}/${DateTime.now().toString()}');
    var uploadTask =
        storageRef.putFile(image, SettableMetadata(contentType: 'image/png'));
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    firestore
        .collection("WallpaperInfo")
        .add({
          "title": title,
          "craeteat": FieldValue.serverTimestamp(),
          "uid": auth?.uid,
          "img": downloadUrl.toString(),
          "PostFavorite": [],
          "username": auth?.displayName,
          "description": description,
          "category": categoryList,
        })
        .then(
          (value) => print("User Added"),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }
}
