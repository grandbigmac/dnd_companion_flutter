import 'dart:developer';

import 'package:dnd_app_flutter/create_character.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/user_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'models/character.dart';
import 'models/class.dart';
import 'models/feature.dart';
import 'models/race.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key, required this.title});
  final String title;

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 100,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    log('Create a New Character');
                    Character activeCharacter = await FirebaseCRUD.getCharacter('nafwPoNFAwponaf');
                    log(activeCharacter.name!);
                    log(activeCharacter.level!.number!.toString());
                    for (int i = 0; i < activeCharacter.level!.featureList!.length; i++) {
                      log(activeCharacter.level!.featureList![i]!.name!);
                      log(activeCharacter.level!.featureList![i]!.effect!);
                    }
                    log(activeCharacter.charClass!.name!);
                    log(activeCharacter.subclass!.name!);



                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: UserHomePage(title: 'Home', activeCharacter: activeCharacter,),
                          inheritTheme: true,
                          ctx: context),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/select_character.png',
                    fit: BoxFit.fill,
                  )
              ),
            ),
            Container(
              width: 250,
              height: 100,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    List<Race> raceList = await FirebaseCRUD.getRaces();
                    List<Class> classList = await FirebaseCRUD.getClasses();

                    //for (int i = 0; i < raceList.length; i++) {
                    //  String race = raceList[i]!.name!;
                    //  String asi = raceList[i]!.asi!;
                    //  String languages = raceList[i]!.languages!;
                    //  String speed = raceList[i].speed.toString();
                    //  log('Race: $race\nASI: $asi\nLanguages: $languages\nSpeed: $speed');
                    //}
                    //log('____________________');
                    //for (int i = 0; i < classList.length; i++) {
                    //  String charClass = classList[i]!.name!;
                    //  List<Feature> features = classList[i]!.featureList!;
                    //  log('Class: $charClass\nFeatures:');
                    //  for (int i = 0; i < features.length; i++) {
                    //    String name = features[i]!.name!;
                    //    String effect = features[i]!.effect!;
                    //    log('Name: $name\nEffect: $effect');
                    //  }
                    //}

                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: CreateCharacter(title: 'Create a New Character', races: raceList, classes: classList, character: Character(),),
                          inheritTheme: true,
                          ctx: context),
                    );

                  },
                  icon: Image.asset(
                    'assets/images/inn_create_new_character.png',
                    fit: BoxFit.fill,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}