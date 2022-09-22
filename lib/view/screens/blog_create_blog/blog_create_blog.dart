import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/classes/file_upload.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  File? image;
  bool? showFeatureImage = false;
  Image? featureImage;
  FileUpload? imageToUpload;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {

      image = File(photo.path.toString());
      List<int> imageBytes = File(photo.path.toString()).readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      imageToUpload = FileUpload();
      imageToUpload!.path = photo.path.toString();
      imageToUpload!.type = 'image';
      imageToUpload!.file = image;

      setState(() {
        showFeatureImage = !showFeatureImage!;
        featureImage = Image.memory(base64Decode(base64Image));
      });

    } else {
      // User canceled the picker
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              height: 80,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Title'),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Body'),
                  TextField(
                    onChanged: (value) {},
                    maxLines: 15,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Feature Image'),
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.green
                    ),
                    margin: const EdgeInsets.only(top: 10.0),
                    child: !showFeatureImage! ? Center(
                      child: InkWell(
                        onTap: _pickImage,
                        child: const Icon(Icons.photo_camera, color: Colors.white),
                      ),
                    ) : Center(
                      child: featureImage,
                    ),
                  )
                ],
              ),
            )

          ],

        ),
      ),
    );
  }
}
