import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile with ChangeNotifier {

  User? _user;

  User get user {

    return _user!;

  }

  set setUser(User user) {

    _user = user;

  }

}