import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../controller/user_provider/user_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool loading = false;

  Future<void> loginUser() async {
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);

    if (_loginFormKey.currentState!.validate()) {
      print({email, password});

      try {
        print("BEFORE");

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        setState(() {
          loading = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            loading = false;
          });

          userProfile.setUser = userCredential;
          GoRouter.of(context).go('/feed');
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        print({"------------------------------> ", e.code, e.message});
        print(e.stackTrace);
      } catch (e) {
        print(e);
      }
    }
  }

  // Future<UserCredential> _signInWithGoogle() async {
  //   // final prefs = await SharedPreferences.getInstance();
  //
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // await prefs.setString('accessToken', credential.accessToken!);
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login', style: TextStyle(color: Colors.black)),
        ),
        body: Center(
          child: Form(
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onChanged: (String text) {
                        email = text;
                      },
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (String text) {
                          password = text;
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ElevatedButton.icon(
                        icon: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Icon(Icons.login_outlined,
                                color: Colors.white),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green //elevated btton background color
                            ),
                        onPressed: () async {
                          await loginUser();
                        },
                        label: const Text('Log In',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 2.0),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //
                    //       await _signInWithGoogle();
                    //
                    //       Future.delayed(const Duration(seconds: 1), () {
                    //
                    //         GoRouter.of(context).go('/feed');
                    //
                    //       });
                    //
                    //
                    //     },
                    //     child: const Text('Google Account', style: TextStyle(color: Colors.black)),
                    //   ),
                    // ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
