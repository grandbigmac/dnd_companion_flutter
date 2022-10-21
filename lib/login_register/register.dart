import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_app_flutter/models/user.dart' as mod;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import '../models/character.dart';
import '../services/firebaseCRUD.dart';
import '../style/textstyles.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  List<TextEditingController> textControllers = [];

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {


    void addUserToFirestore(String uId) async {
      mod.User user = mod.User(
        name: nameTextController.text.toString(),
        uId: uId,
        activeCharacter: Character(),
        characters: [],
      );
      await FirebaseCRUD.addNewUser(user: user);

      signOut();

      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const LoginPage(title: 'Log in',),
            inheritTheme: true,
            ctx: context),
      );
    }

    Future<void> signUpFirebaseAuth() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text,
        );

        log(userCredential.user!.uid.toString());

        log('successfully created account!');
        addUserToFirestore(userCredential.user!.uid);
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          SnackBar snackBar = const SnackBar(
            content: Text(
                'The provided password is too weak!'
            ),
          );

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        else if (e.code == 'email-already-in-use') {
          SnackBar snackBar = const SnackBar(
            content: Text(
                'An account already exists with this email!'
            ),
          );

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        else {
          log('Error!');
        }
      }
    }

    void _termsAndConditions(context) {
      AlertDialog alert = const AlertDialog(
        title: Text(
          'Terms and Conditions',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Aliquam mollis odio a magna pellentesque varius. Duis '
              'lacinia nunc elit, eget hendrerit nisl tincidunt nec. '
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Duis feugiat vestibulum elit sit amet feugiat. Pellentesque '
              'commodo, mauris a interdum ultricies, tellus libero laoreet '
              'tortor, in tincidunt lorem mi eget magna. Praesent diam massa, '
              'ornare varius convallis at, volutpat id magna. Donec interdum '
              'eget leo tincidunt convallis. In molestie laoreet erat. Nulla '
              'lobortis vitae nulla in consequat. Integer nibh eros, vulputate '
              'at ante malesuada, gravida venenatis leo. Nunc tempor, nisl non '
              'posuere pharetra, neque metus pretium nulla, ac gravida neque '
              'velit non justo. In quis tellus quis arcu faucibus ultricies '
              'in quis augue. Nam ullamcorper congue luctus.',
          textAlign: TextAlign.center,),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void _isFormValid() {

      if (nameTextController.text.isEmpty) {
        log('false');
        SnackBar snackBar = const SnackBar(
          content: Text(
              'Enter your full name.'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else if (emailTextController.text.isEmpty) {
        SnackBar snackBar = const SnackBar(
          content: Text(
              'Enter your email address.'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else if (passwordTextController.text.isEmpty) {
        SnackBar snackBar = const SnackBar(
          content: Text(
              'Enter your password.'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else if (confirmPasswordTextController.text.isEmpty) {
        SnackBar snackBar = const SnackBar(
          content: Text(
              'You must reenter your password.'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else if (passwordTextController.text != confirmPasswordTextController.text) {
        SnackBar snackBar = const SnackBar(
          content: Text(
              'Passwords must match!'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else if (passwordTextController.text.length < 8) {
        SnackBar snackBar = const SnackBar(
          content: Text(
              'Your password must be longer than 8 characters!'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else if (!_isChecked) {
        SnackBar snackBar = const SnackBar(
          content: Text(
              'You must agree to the terms and conditions!'
          ),
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      else {
        log('True');
        signUpFirebaseAuth();
      }
    }


    Widget _pageHeader = Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Enter your details to create a new account.',
            style: contentText,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    Widget _registrationForm = Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameTextController,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Full Name',
                        labelStyle: contentText
                    ),
                  ),
                  Text(
                    'Enter your full name.',
                    style: headerText,
                  )
                ],
              )
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: emailTextController,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Email Address',
                        labelStyle: contentText
                    ),
                  ),
                  Text(
                    'Enter your email address.',
                    style: headerText,
                  )
                ],
              )
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: passwordTextController,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: contentText
                    ),
                  ),
                  Text(
                    'Password must be longer than 8 characters.',
                    style: headerText,
                  )
                ],
              )
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordTextController,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: contentText
                    ),
                  ),
                  const Text(
                    'Confirm your password.',
                    style: headerText,
                  )
                ],
              )
          ),
        ],
      ),
    );

    Widget _pageFooter = Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (val) {
                  setState(() {
                    _isChecked = val!;

                    if (_isChecked) {
                      log('true');
                    }
                    else {
                      log('false');
                    }
                  });
                },
              ),
              const Text(
                'I have read and agreed to the',
                style: headerText,
              ),
              TextButton(
                onPressed: () {
                  _termsAndConditions(context);
                },
                child: const Text(
                  'Terms and Conditions.',
                  style: headerText,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator(),),
                    );

                    _isFormValid();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'CONFIRM',
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[],
      ),
      body: ListView(
        children: [
          _pageHeader,
          _registrationForm,
          _pageFooter
        ],
      ),
    );
  }

  SnackBar snackBar(String snackBarText) {
    return SnackBar(
      content: Text(
        snackBarText,
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

}