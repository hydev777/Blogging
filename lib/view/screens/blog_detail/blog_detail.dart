import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controller/user_provider/user_provider.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  Map<String, dynamic> postsDetails = {};

  getDetails() {
    final db = FirebaseFirestore.instance;

    final docRef = db.collection("posts").doc(widget.id);

    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          postsDetails = {
            "title": data['title'],
            "body": data["body"],
            "category": data["category"],
            "image": data["image"],
          };
        });

        print(postsDetails["title"]);
        print(widget.id);
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserCredential userProfile = Provider.of<UserProfile>(context).user;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(postsDetails["title"] ?? "-",
                      style: const TextStyle(color: Colors.black)),
                  background: postsDetails["image"] != null
                      ? Image.memory(
                          base64Decode(postsDetails["image"]!),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        )
                      : const FlutterLogo()),
              leading: IconButton(
                onPressed: () {
                  context.go('/feed');
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'by: ${userProfile.user!.email}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Text(postsDetails["body"] ?? "-");
                }, childCount: 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
