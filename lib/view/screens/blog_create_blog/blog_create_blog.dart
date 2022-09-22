import 'package:flutter/material.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {


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
                    maxLines: 10,
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
                    child: Center(
                      child: InkWell(
                        onTap: () {

                          print("Image");

                        },
                        child: const Icon(Icons.photo_camera),
                      ),
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
