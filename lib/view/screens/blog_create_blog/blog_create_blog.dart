import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/classes/file_upload.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  File? image;
  String? base64Image;
  bool? showFeatureImage = false;
  Image? featureImage;
  FileUpload? imageToUpload;

  String? title;
  String? body;
  List<String>? categories = [];
  String? categoryDropdownValue;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {

      image = File(photo.path.toString());
      List<int> imageBytes = File(photo.path.toString()).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      imageToUpload = FileUpload();
      imageToUpload!.path = photo.path.toString();
      imageToUpload!.type = 'image';
      imageToUpload!.file = image;

      setState(() {
        showFeatureImage = !showFeatureImage!;
        featureImage = Image.memory(base64Decode(base64Image!));
      });

    } else {
      // User canceled the picker
    }
  }

  Future<void> getCategories() async {

    final db = FirebaseFirestore.instance;

    await db.collection("category").get().then((event) {
      for (var doc in event.docs) {

        setState(() {
          categories!.add(doc.data()['name']);
        });

      }
    });

    if(categories!.isNotEmpty) {

      categoryDropdownValue = categories![0];

    }

  }

  @override
  void initState() {
    super.initState();

    getCategories();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            onPressed: () {
              context.go('/feed');
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
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
                          controller: titleController,
                          onChanged: (text) {

                            title = text;

                          },
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
                      controller: bodyController,
                      onChanged: (text) {

                        body = text;

                      },
                      maxLines: 10,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text('Category'),
                    SizedBox(width: 10,),
                    DropdownButton(
                      onChanged: (String? value) {

                        setState(() {
                          categoryDropdownValue = value;
                        });

                      },
                      value: categoryDropdownValue,
                      items: categories!.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                      height: 180,
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
              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){

                      final db = FirebaseFirestore.instance;

                      if(title!.isNotEmpty && body!.isNotEmpty && categoryDropdownValue!.isNotEmpty && base64Image!.isNotEmpty) {

                        final data = {"title": title, "body": body, "category": categoryDropdownValue, "image": base64Image};

                        db.collection("posts").add(data).then((documentSnapshot) {

                          print("Added Data with ID: ${documentSnapshot.id}");

                          setState(() {
                            titleController.clear();
                            bodyController.clear();
                            base64Image = "";
                            showFeatureImage = false;
                          });

                        });

                      }

                    }, child: const Text('Create', style: TextStyle(fontSize: 16, color: Colors.black),))
                  ],
                ),
              )

            ],

          ),
        ),
      ),
    );
  }
}
