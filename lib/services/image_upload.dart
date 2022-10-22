import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  ImageUploadState createState() => ImageUploadState();
}

class ImageUploadState extends State<ImageUpload> {
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
