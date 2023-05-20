import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

void showSnackbar({required BuildContext context, required String content}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content)
    )
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackbar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> takePhotoFromCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackbar(context: context, content: e.toString());
  }
  return image;
}

var logger = Logger();