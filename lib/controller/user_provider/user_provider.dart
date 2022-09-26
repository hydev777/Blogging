import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile with ChangeNotifier {

  UserCredential? _user;

  UserCredential get user {

    return _user!;

  }

  set setUser(UserCredential user) {

    _user = user;

  }

}