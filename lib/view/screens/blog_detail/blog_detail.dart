import 'dart:convert';

import 'package:blog_solid/controller/blog_provider/blog_provider.dart';
import 'package:blog_solid/model/post.dart';
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

  void getDetails() {
    Provider.of<PostsProvider>(context, listen: false)
        .getPostDetails(widget.id!);
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserCredential userProfile = Provider.of<UserProfile>(context).user;
    Post? postDetail = Provider.of<PostsProvider>(context).postDetail;

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
                  title: Text(postDetail!.title ?? "-",
                      style: const TextStyle(color: Colors.black)),
                  background: postDetail.image != ''
                      ? Image.memory(
                          base64Decode(postDetail.image!),
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
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Text(postDetail.body ?? "-");
                }, childCount: 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
