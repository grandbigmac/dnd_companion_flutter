import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_app_flutter/login_register/register.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import '../models/character.dart';
import '../style/textstyles.dart';
import '../user_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SizedBox dividingLineLight = SizedBox(
    height: 10.0,
    child: Center(
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
        height: 1.0,
        color: const Color(0xFF303B47).withOpacity(0.2),
      ),
    ),
  );

  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Widget _login_elements = Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your login details:',
              style: contentText,
            ),
            TextFormField(
              controller: emailAddressController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  signIn();
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Login',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: const RegistrationPage(title: 'Register'),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Text(
                'Click here to register\nfor a new account',
                style: contentText,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );


    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }
            else if (snapshot.hasData) {
              //Check firestore for this user's active character
              String uId = FirebaseAuth.instance.currentUser!.uid;
              log(uId);
              loginGetUser(uId);
              return Container();
            }
            else {
              return _login_elements;
            }
          },
        )
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(),),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddressController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        SnackBar snackbar = snackBar('Incorrect password entered!');
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      else if (e.code == 'invalid-email') {
        SnackBar snackbar = snackBar('Invalid email address!');
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      else if (e.code == 'user-not-found') {
        SnackBar snackbar = snackBar('No user found with that email address!');
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      else {
        SnackBar snackbar = snackBar('Something went wrong!');
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        log(e.code);
      }
    }
    Navigator.pop(context);
  }

  SnackBar snackBar(String snackBarText) {
    return SnackBar(
      content: Text(
        snackBarText,
      ),
    );
  }

  void loginGetUser(String uId) async {
    Character activeChar = await FirebaseCRUD.getCharacter(uId);

    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.bottomToTop,
          child: UserHomePage(title: 'Home', activeCharacter: activeChar,),
          inheritTheme: true,
          ctx: context),
    );
  }
}