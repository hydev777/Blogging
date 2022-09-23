import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              border: Border(bottom: BorderSide(width: 2))
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
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                        ),
                  ),
                  const Text('Wilson Toribio',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text('Magician', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(

              children: [

                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 80,
                  decoration: const BoxDecoration(

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Username', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('wtoribio', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 80,
                  decoration: const BoxDecoration(

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('wilson@person.com', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 80,
                  decoration: const BoxDecoration(

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Creation date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('9/22/2022', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),


              ],

            ),
          )
        ],
      ),
    );
  }
}
