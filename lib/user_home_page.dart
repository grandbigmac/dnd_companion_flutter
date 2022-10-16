import 'dart:developer';

import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/character.dart';
import 'models/class.dart';
import 'models/feature.dart';

TextStyle titleStyle = const TextStyle(
  color: Colors.red,
  fontSize: 20,
  fontFamily: 'Roboto',
);
const TextStyle contentText = TextStyle(
  fontSize: 14,
  fontFamily: 'Roboto',
  color: Color(0xFF455566),
);
const TextStyle headerText = TextStyle(
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
          style: headerText,
        ),
        Text(
          activeCharacter.name!,
          style: contentText,
        ),
        const Text(
          'Level',
          style: headerText,
        ),
        Text(
          activeCharacter.level!.number!.toString(),
          style: contentText,
        ),
        const Divider(),
        const Text(
          'Race',
          style: headerText,
        ),
        Text(
          activeCharacter.race!.name!,
          style: contentText,
        ),
        const Divider(),
        const Text(
          'Class',
          style: headerText,
        ),
        Text(
          activeCharacter.charClass!.name!,
          style: contentText,
        ),
        const Text(
          'Subclass',
          style: headerText,
        ),
        Text(
          activeCharacter.subclass!.name!,
          style: contentText,
        )
      ],
    );
  }

  Widget _buildList(Feature list) {
    return Card(
      child: ExpansionTile(
        leading: const Icon(
          Icons.account_circle,
        ),
        title: Text(
          list.name!,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              list.effect!,
            ),
          )
        ],
      ),
    );
  }

  Padding featuresList(List<Feature> FeatureList, String type) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.blueGrey,
        height: 200,
        child: ListView(
          children: [
            Text(
              '$type Features',
              style: headerText,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: FeatureList.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildList(FeatureList[index]),
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeCharacter = widget.activeCharacter;
    List<Feature> featureList = activeCharacter.level!.featureList!;

    List<Feature> classFeatureList = [];
    List<Feature> raceFeatureList = [];
    List<Feature> subclassFeatureList = [];

    for (int i = 0; i < featureList.length; i++) {
      if (featureList[i].source == 'class') {
        classFeatureList.add(featureList[i]);
      }
      else if (featureList[i].source == 'race') {
        raceFeatureList.add(featureList[i]);
      }
      else if (featureList[i].source == 'subclass') {
        subclassFeatureList.add(featureList[i]);
      }
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
                homePageHead,
                bodyContent(activeCharacter),
                featuresList(raceFeatureList, 'Race'),
                featuresList(classFeatureList, 'Class'),
                featuresList(subclassFeatureList, 'Subclass'),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buttonScroll,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}