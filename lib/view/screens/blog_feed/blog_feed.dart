import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controller/blog_provider/blog_provider.dart';
import '../../../controller/user_provider/user_provider.dart';
import '../../../model/post.dart';
import '../../widgets/blog_item/blog_item.dart';

class BlogFeed extends StatefulWidget {
  const BlogFeed({Key? key}) : super(key: key);

  @override
  State<BlogFeed> createState() => _BlogFeedState();
}

class _BlogFeedState extends State<BlogFeed> {
  List<String>? categories = ["none"];
  String? categoryDropdownValue;

  Future<void> getCategories() async {
    final db = FirebaseFirestore.instance;

    await db.collection("category").get().then((event) {
      for (var doc in event.docs) {
        setState(() {
          categories!.add(doc.data()['name']);
        });
      }
    });

    if (categories!.isNotEmpty) {
      categoryDropdownValue = categories![0];
    }
  }

  void loadRecords() {
    User? user = Provider.of<UserProfile>(context, listen: false).user.user;
    Provider.of<PostsProvider>(context, listen: false).fillPosts(user!.uid);
  }

  @override
  void initState() {
    loadRecords();
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProfile>(context).user.user;
    List<Post>? posts = Provider.of<PostsProvider>(context).posts;
    PostsProvider postsActions =
        Provider.of<PostsProvider>(context, listen: false);
    bool postEmpty = Provider.of<PostsProvider>(context).postEmpty;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed', style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text('Filter by: '),
                    DropdownButton(
                      onChanged: (String? value) {
                        setState(() {
                          categoryDropdownValue = value;
                        });

                        postsActions.filterPosts(user!.uid, value!);
                      },
                      value: categoryDropdownValue,
                      items: categories!
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: posts!.isNotEmpty
                  ? ListView(
                      children: [
                        ...posts
                            .map(
                              (post) => BlogItem(
                                id: post.id,
                                title: post.title,
                                body: post.body,
                                image: post.image ?? '',
                              ),
                            )
                            .toList(),
                      ],
                    )
                  : postEmpty
                      ? const Center(
                          child: Text(
                            'No posts to show',
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  user!.email!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: const Icon(
                  Icons.message,
                  color: Colors.black,
                ),
                title: const Text('Profile'),
                onTap: () {
                  context.go('/profile');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
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
            context.go('/create');
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
