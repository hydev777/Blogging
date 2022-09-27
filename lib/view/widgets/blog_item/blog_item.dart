import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({Key? key, this.id, this.title, this.body, this.image})
      : super(key: key);

  final String? id;
  final String? title;
  final String? body;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.memory(base64Decode(image!)),
        contentPadding: const EdgeInsets.all(10),
        title: Text(title!),
        subtitle:
            Text(body!.length > 60 ? "${body!.substring(0, 60)}..." : body!),
        onTap: () {
          context.goNamed('blog_detail', params: <String, String>{'id': id!});
        },
      ),
    );
  }
}
