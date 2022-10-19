import 'dart:developer';

import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/style/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/character.dart';
import 'models/class.dart';
import 'models/feature.dart';
late Character activeCharacter;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.title, required this.activeCharacter});
  final String title;
  final Character activeCharacter;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  @override
  Widget build(BuildContext context) {
    activeCharacter = widget.activeCharacter;

    Widget tempHomePage() {

      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 35,
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  //buttons
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('CONTINUE', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tempHomePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}