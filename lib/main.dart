import 'package:blog_solid/view/screens/blog_create_blog/blog_create_blog.dart';
import 'package:blog_solid/view/screens/blog_detail/blog_detail.dart';
import 'package:blog_solid/view/screens/blog_feed/blog_feed.dart';
import 'package:blog_solid/view/screens/blog_home/blog_home.dart';
import 'package:blog_solid/view/screens/blog_user_profile/blog_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_solid/view/screens/blog_login/blog_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const Login();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const BlogHome();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const BlogUserProfile();
        },
      ),
      GoRoute(
        path: '/feed',
        builder: (BuildContext context, GoRouterState state) {
          return const BlogFeed();
        },
      ),
      GoRoute(
        path: '/blog/1',
        builder: (BuildContext context, GoRouterState state) {
          return const BlogDetail();
        },
      ),
      GoRoute(
        path: '/blog/create',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateBlog();
        },
      ),
    ],
  );
}
