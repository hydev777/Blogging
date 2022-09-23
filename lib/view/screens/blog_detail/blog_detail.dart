import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 160.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('What is a person?'),
                background: FlutterLogo(),
              ),
              leading: IconButton(
                onPressed: () {

                  context.go('/feed');

                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Wilson Toribio')),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
