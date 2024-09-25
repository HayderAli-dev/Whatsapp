import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

//Snack Bar Method
void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

//Image Picking Method
Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString() + ' This is what');
  }
  return image;
}

Future<Uint8List?> pickImageFromGallery2(BuildContext context) async {
  Uint8List? image;

  try {
    // Pick an image file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      image =  result.files.single.bytes;
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString() + 'This is what');
    print(e.toString());
  }

  return image;
}
