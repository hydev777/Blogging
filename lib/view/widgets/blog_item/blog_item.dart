import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(size: 72.0),
        title: const Text('Three-line ListTile'),
        subtitle: const Text('A sufficiently long subtitle warrants three lines.'),
        isThreeLine: true,
        onTap: () {

          context.go('/blog/1');

        },
      ),
    );
  }
}
