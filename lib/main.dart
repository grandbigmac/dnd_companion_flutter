import 'package:dnd_app_flutter/launch_page.dart';
import 'package:dnd_app_flutter/login_register/login.dart';
import 'package:dnd_app_flutter/user_home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: LoginPage(title: 'Login',)));
}


