import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider
final commonFirebaseStorageReposioryProvider = Provider((ref) {
  return CommonFirebaseStorageReposiory(storage: FirebaseStorage.instance);
});

class CommonFirebaseStorageReposiory {
  final FirebaseStorage storage;

  CommonFirebaseStorageReposiory({required this.storage});
  Future<String> storeFileTFirebase(String ref, File file) async {
//Uploading file
  print(ref);
    UploadTask uploadTask = storage.ref().child(ref).putFile(file);
//Getting dataSnapshot
    TaskSnapshot snapshot = await uploadTask;

    print('Snapshot is $snapshot');

    //getting url
    String downloadURL = await snapshot.ref.getDownloadURL();

    print('Download URL is $downloadURL');

    return downloadURL;
  }
}
