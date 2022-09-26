import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({Key? key, this.id, this.title, this.body}) : super(key: key);

  final String? id;
  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(size: 72.0),
        contentPadding: const EdgeInsets.all(10),
        title: Text(title!),
        subtitle: Text(body!.length > 60 ? "${body!.substring(0, 60)}...": body!),
        onTap: () {

          context.go('/blog/1');
          context.goNamed('blog_detail', params: <String, String>{'id': id!});
          

        },
      ),
    );
  }
}
