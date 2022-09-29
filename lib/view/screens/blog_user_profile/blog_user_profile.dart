import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controller/user_provider/user_provider.dart';
import '../../widgets/detail_field/detail_field.dart';

class BlogUserProfile extends StatefulWidget {
  const BlogUserProfile({Key? key}) : super(key: key);

  @override
  State<BlogUserProfile> createState() => _BlogUserProfileState();
}

class _BlogUserProfileState extends State<BlogUserProfile> {
  @override
  Widget build(BuildContext context) {
    UserCredential userProfile = Provider.of<UserProfile>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            context.go('/feed');
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                        ),
                  ),
                  Text(
                    userProfile.user!.email!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                DetailField(
                  title: 'Email',
                  content: userProfile.user!.email,
                ),
                DetailField(
                  title: 'Email Verified',
                  content: userProfile.user!.emailVerified.toString(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
