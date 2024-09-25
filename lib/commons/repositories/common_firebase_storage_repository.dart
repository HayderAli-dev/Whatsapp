import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider
final CommonFirebaseStorageReposioryProvider = Provider((ref) {
  return CommonFirebaseStorageReposiory(storage: FirebaseStorage.instance);
});

class CommonFirebaseStorageReposiory {
  final FirebaseStorage storage;

  CommonFirebaseStorageReposiory({required this.storage});
  Future<String> storeFileTFirebase(String ref, File file) async {
//Uploading file
    UploadTask uploadTask = storage.ref().child(ref).putFile(file);
//Getting dataSnapshot
    TaskSnapshot snapshot = await uploadTask.snapshot;

    //getting url
    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }
}
