import 'package:blog_solid/view/screens/blog_create_blog/blog_create_blog.dart';
import 'package:blog_solid/view/screens/blog_detail/blog_detail.dart';
import 'package:blog_solid/view/screens/blog_feed/blog_feed.dart';
import 'package:blog_solid/view/screens/blog_user_profile/blog_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_solid/view/screens/blog_login/blog_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'controller/blog_provider/blog_provider.dart';
import 'controller/user_provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserProfile(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PostsProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Blog App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.white,
          ),
          textTheme:
              GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        ),
        routerConfig: _router,
      ),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      var currentUser = FirebaseAuth.instance.currentUser;
      final bool loggedIn = currentUser != null;
      final bool loggingIn = state.subloc == '/login';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      if (loggingIn) {
        return '/feed';
      }

      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const Login();
        },
      ),
      GoRoute(
        path: '/feed',
        builder: (BuildContext context, GoRouterState state) {
          return const BlogFeed();
        },
      ),
      GoRoute(
        name: 'blog_detail',
        path: '/blog/:id',
        builder: (BuildContext context, GoRouterState state) {
          return BlogDetail(
            id: state.params['id'],
          );
        },
      ),
      GoRoute(
        path: '/create',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateBlog();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const BlogUserProfile();
        },
      ),
    ],
  );
}
