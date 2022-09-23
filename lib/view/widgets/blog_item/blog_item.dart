import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({Key? key, this.title, this.body}) : super(key: key);

  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(size: 72.0),
        title: Text(title!),
        subtitle: Text(body!),
        onTap: () {

          context.go('/blog/1');

        },
      ),
    );
  }
}
