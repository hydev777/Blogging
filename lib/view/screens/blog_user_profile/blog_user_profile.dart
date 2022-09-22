import 'package:flutter/material.dart';

class BlogUserProfile extends StatefulWidget {
  const BlogUserProfile({Key? key}) : super(key: key);

  @override
  State<BlogUserProfile> createState() => _BlogUserProfileState();
}

class _BlogUserProfileState extends State<BlogUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green
            ),
            child: const Text('Profile'),
          ),
          Text('Email'),
          Text('Post created'),
        ],
      ),
    );
  }
}
