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
const TextStyle headerText = TextStyle(
  fontSize: 14,
  fontFamily: 'Roboto',
  color: Color(0xFF455566),
);
const TextStyle contentText = TextStyle(
  fontSize: 12,
  fontFamily: 'Roboto',
  color: Color(0xFF329BD9),
);

late Character activeCharacter;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.title, required this.activeCharacter});
  final String title;
  final Character activeCharacter;

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

  Widget bodyContent(Character activeCharacter) {
    return Column(
      children: [
        const Text(
          'Character Name',
          style: contentText,
        ),
        Text(
          activeCharacter.name!,
          style: headerText,
        ),
        const Text(
          'Level',
          style: contentText,
        ),
        Text(
          activeCharacter.level!.number!.toString(),
          style: headerText,
        ),
        Divider(),
        const Text(
          'Race',
          style: contentText,
        ),
        Text(
          activeCharacter.race!.name!,
          style: headerText,
        ),
        Divider(),
        const Text(
          'Class',
          style: contentText,
        ),
        Text(
          activeCharacter.charClass!.name!,
          style: headerText,
        ),
        const Text(
          'Subclass',
          style: contentText,
        ),
        Text(
          activeCharacter.subclass!.name!,
          style: headerText,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    activeCharacter = widget.activeCharacter;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            homePageHead,
            bodyContent(activeCharacter),
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