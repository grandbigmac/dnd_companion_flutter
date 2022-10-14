import 'dart:developer';

import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/character.dart';
import 'models/class.dart';

TextStyle titleStyle = const TextStyle(
  color: Colors.red,
  fontSize: 20,
  fontFamily: 'Roboto',
);

late Character activeCharacter;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.title});
  final String title;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {




  Widget homePageHead = Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Center(
                  child: Text(
                    'Get logged in guy\'s character name',
                    style: titleStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
  );

  Widget buttonScroll = SizedBox(
    height: 100,
    width: double.infinity,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Container(
                width: 250,
                height: 100,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      log('Create a New Character');
                      activeCharacter = await FirebaseCRUD.getCharacter('nafwPoNFAwponaf');

                      List list = activeCharacter.level!.featureList!;

                    },
                    icon: Image.asset(
                      'assets/images/inn_create_new_character.png',
                      fit: BoxFit.fill,
                    )
                ),
              ),
            ),
            Card(
              child: Container(
                width: 250,
                height: 100,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      log('Select a Character');
                    },
                    icon: Image.asset(
                      'assets/images/select_character.png',
                      fit: BoxFit.fill,
                    )
                ),
              ),
            ),
            Card(
              child: Container(
                width: 250,
                height: 100,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      log('idk yet');
                    },
                    icon: Image.asset(
                      'assets/images/inn_create_new_character.png',
                      fit: BoxFit.fill,
                    )
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            homePageHead,
            Align(
              alignment: Alignment.bottomCenter,
              child: buttonScroll,
            )
          ],
        ),
      ),
    );
  }
}