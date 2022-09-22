import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/blog_item/blog_item.dart';

class BlogFeed extends StatefulWidget {
  const BlogFeed({Key? key}) : super(key: key);

  @override
  State<BlogFeed> createState() => _BlogFeedState();
}

class _BlogFeedState extends State<BlogFeed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          title: const Text('Feed'),
          actions: [
            IconButton(onPressed: () {

              context.go('/blog/profile');

            }, icon: const Icon(Icons.person))
          ],
        ),

        body: ListView(
          children: const [

            BlogItem(),
            BlogItem(),
            BlogItem(),
            BlogItem(),
            BlogItem(),
            BlogItem(),

          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/blog/create');
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),

      ),
    );
  }
}
