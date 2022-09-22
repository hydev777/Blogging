import 'package:flutter/material.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key}) : super(key: key);

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog Detail'),
        ),
        body: const CustomScrollView(
          slivers: [

            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('SliverAppBar'),
                background: FlutterLogo(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
