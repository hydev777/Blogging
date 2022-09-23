import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/blog_item/blog_item.dart';

class BlogFeed extends StatefulWidget {
  const BlogFeed({Key? key}) : super(key: key);

  @override
  State<BlogFeed> createState() => _BlogFeedState();
}

class _BlogFeedState extends State<BlogFeed> {

  List<Map<String, dynamic>>? posts = [];
  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance.collection('users').snapshots();

  Future<void> getPosts() async {

    final db = FirebaseFirestore.instance;

    db.collection("posts").snapshots().listen((event) {

      posts = [];

      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            setState(() {
              posts!.add({ "title" : change.doc.data()!['title'], "body": change.doc.data()!['body'] });
            });
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            print("Removed City: ${change.doc.data()}");
            break;
        }
      }

    });

  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed', style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: [

            ...posts!.map((post) => BlogItem(title: post['title'], body: post['body'],)).toList(),

          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Wilson Toribio',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.black,),
                title: const Text('Profile'),
                onTap: () {

                  context.go('/blog/profile');

                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined, color: Colors.black,),
                title: const Text('Log out'),
                onTap: () async {

                  await FirebaseAuth.instance.signOut();
                  await Future.delayed(Duration.zero, () {

                    context.go('/login');

                  });

                },
              ),
            ],
          ),
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
