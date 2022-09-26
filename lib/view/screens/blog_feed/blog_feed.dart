import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controller/user_provider/user_provider.dart';
import '../../widgets/blog_item/blog_item.dart';

class BlogFeed extends StatefulWidget {
  const BlogFeed({Key? key}) : super(key: key);

  @override
  State<BlogFeed> createState() => _BlogFeedState();
}

class _BlogFeedState extends State<BlogFeed> {
  List<Map<String, dynamic>>? posts = [];
  List<String>? categories = ["none"];
  String? categoryDropdownValue;

  Future<void> getPosts() async {
    final db = FirebaseFirestore.instance;
    UserCredential userProfile = Provider.of<UserProfile>(context, listen: false).user;

    db.collection("posts").where("owner", isEqualTo: userProfile.user!.uid).snapshots().listen((event) {
      posts = [];

      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            setState(() {
              posts!.add({
                "id": change.doc.id,
                "title": change.doc.data()!['title'],
                "body": change.doc.data()!['body'],
                "category": change.doc.data()!['category'],
                "image": change.doc.data()!['image'],
              });
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

  @override
  void initState() {
    getPosts();
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    UserCredential userProfile = Provider.of<UserProfile>(context).user;

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

                        final db = FirebaseFirestore.instance;
                        UserCredential userProfile = Provider.of<UserProfile>(context, listen: false).user;
                        posts = [];

                        db.collection("posts").where("category", isEqualTo: value).where("owner", isEqualTo: userProfile.user!.uid).get().then(
                          (doc) async {
                            if (value != "none") {
                              doc.docs.forEach((element) {
                                setState(() {
                                  posts!.add(element.data());
                                });
                              });
                            } else {
                              await db.collection("posts").where("owner", isEqualTo: userProfile.user!.uid).get().then((event) {
                                for (var doc in event.docs) {
                                  setState(() {
                                    posts!.add({
                                      "id": doc.id,
                                      "title": doc.data()['title'],
                                      "body": doc.data()['body'],
                                      "category": doc.data()['category'],
                                      "image": doc.data()['image'],
                                    });
                                  });
                                }
                              });
                            }
                          },
                          onError: (e) => print("Error completing: $e"),
                        );
                      },
                      value: categoryDropdownValue,
                      items: categories!.map<DropdownMenuItem<String>>((String value) {
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
                        ...posts!
                            .map(
                              (post) => BlogItem(
                                id: post['id'],
                                title: post['title'],
                                body: post['body'],
                                image: post['image'] ?? '',
                              ),
                            )
                            .toList(),
                      ],
                    )
                  : const Center(child: Text('No posts to show', )),
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
                  userProfile.user!.email!,
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
            print('CREATE');
            context.go('/create');
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
