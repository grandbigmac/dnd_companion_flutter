import 'dart:core';
import 'dart:developer';

import 'package:dnd_app_flutter/launch_page.dart';
import 'package:dnd_app_flutter/services/dice_rolls.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/style/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/background.dart';
import '../models/character.dart';
import '../models/class.dart';
import '../models/feature.dart';
import '../models/level.dart';
import '../models/race.dart';
import '../models/skills_languages_tools.dart' as sk;
import '../models/subclass.dart';
import '../user_home_page.dart';
import 'choose_background.dart';

//CHOOSE NAME AND FINALISE
class ReviewNewCharacter extends StatefulWidget {
  const ReviewNewCharacter({super.key, required this.title, required this.backuplist, required this.races, required this.classes, required this.activeChar, required this.character, required this.scores, required this.backgrounds});
  final String title;
  final List<Race> races;
  final List<Race> backuplist;
  final List<Class> classes;
  final Character character;
  final List<int> scores;
  final List<Background> backgrounds;
  final Character activeChar;

  @override
  State<ReviewNewCharacter> createState() => _ChooseNameAndReview();
}
class _ChooseNameAndReview extends State<ReviewNewCharacter> {
  List<int> newScores = [];
  String uId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    Character activeChar = widget.activeChar;
    Character character = widget.character;
    //STR, DEX, CON, INT, WIS, CHA
    newScores = widget.scores;
    List<int> abilityScores = newScores;
    List<int> postRaceASI = [];
    List<String> stringMods = [];
    List<Race> raceList = widget.races;
    List<Race> backupList = raceList;
    List<Class> classList = widget.classes;
    List<int> scores = widget.scores;
    List<Background> backgrounds = widget.backgrounds;
    List<String> languageList = character.race!.languages!.split(',');
    for (String i in character.background!.languages!) {
      if (!languageList.contains(i)) {
        languageList.add(i);
      }
    }
    String languages = '';
    for (String i in languageList) {
      languages = '$languages, $i';
    }
    languages = languages.substring(1);

    Container characterDetails() {
      String charClass = character.charClass!.name!;
      String charRace = character.race!.name!;
      List<Feature> classFeatures = character.charClass!.featureList!;
      List<Feature> raceFeatures = character.race!.featureList!;
      List<String> proficienciesFromBackground = character.background!.skillProf!;
      String backgroundProfString = '';
      for (int i = 0; i < proficienciesFromBackground!.length; i++) {
        if (i == 0) {
          backgroundProfString = proficienciesFromBackground[i];
        }
        else {
          backgroundProfString = backgroundProfString + ', ' + proficienciesFromBackground[i];
        }
      }
      List<String> proficienciesFromClass = character.proficiencies!;
      String classProfString = '';
      for (int i = 0; i < proficienciesFromClass!.length; i++) {
        if (i == 0) {
          classProfString = proficienciesFromClass[i];
        }
        else {
          classProfString = classProfString + ', ' + proficienciesFromClass[i];
        }
      }

      Widget abilityScoresRow() {
        log('it is calling atleast');
        for (int i in abilityScores) {
          postRaceASI.add(i);
        }

        List<String> racialIncrease = [];
        if (character.race!.asi!.contains(",")){
          racialIncrease = character.race!.asi!.split(', ');

          for (int i = 0; i < racialIncrease.length; i++) {
            int number;
            if (racialIncrease.length > 0){
              number = int.parse(racialIncrease[i][1]);

              if (racialIncrease[i].contains('STR')) {
                postRaceASI[0] = postRaceASI[0] + number;
                log('+STR');
              }
              else if (racialIncrease[i].contains('DEX')) {
                postRaceASI[1] = postRaceASI[1] + number;
                log('+DEX');
              }
              else if (racialIncrease[i].contains('CON')) {
                postRaceASI[2] = postRaceASI[2] + number;
                log('+CON');
              }
              else if (racialIncrease[i].contains('INT')) {
                postRaceASI[3] = postRaceASI[3] + number;
                log('INT');
              }
              else if (racialIncrease[i].contains('WIS')) {
                postRaceASI[4] = postRaceASI[4] + number;
                log('+WIS');
              }
              else if (racialIncrease[i].contains('CHA')) {
                postRaceASI[5] = postRaceASI[5] + number;
                log('+CHA');
              }
            }
          }
        }
        else {
          int number = int.parse(character.race!.asi![1]);
          log(number.toString());

          if (character.race!.asi!.contains('STR')) {
            postRaceASI[0] = postRaceASI[0] + number;
            log('+STR');
          }
          else if (character.race!.asi!.contains('DEX')) {
            postRaceASI[1] = postRaceASI[1] + number;
            log('+DEX');
          }
          else if (character.race!.asi!.contains('CON')) {
            postRaceASI[2] = postRaceASI[2] + number;
            log('+CON');
          }
          else if (character.race!.asi!.contains('INT')) {
            postRaceASI[3] = postRaceASI[3] + number;
            log('INT');
          }
          else if (character.race!.asi!.contains('WIS')) {
            postRaceASI[4] = postRaceASI[4] + number;
            log('+WIS');
          }
          else if (character.race!.asi!.contains('CHA')) {
            postRaceASI[5] = postRaceASI[5] + number;
            log('+CHA');
          }
        }
        log(racialIncrease.length.toString());
        log(character.race!.asi!);


        for (int i = 0; i < postRaceASI.length; i++) {
          double score = postRaceASI[i].toDouble();
          score = (score - 10) / 2;
          int mod = score.floor();
          if (mod < 0) {
            stringMods.add(mod.toString());
          }
          else {
            stringMods.add('+$mod');
          }
        }


        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'STR',
                    style: contentText,
                  ),
                  Text(
                    '${stringMods[0]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${postRaceASI[0]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'DEX',
                    style: contentText,
                  ),
                  Text(
                    stringMods[1],
                    style: titleStyle,
                  ),
                  Text(
                    '${postRaceASI[1]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'CON',
                    style: contentText,
                  ),
                  Text(
                    stringMods[2],
                    style: titleStyle,
                  ),
                  Text(
                    '${postRaceASI[2]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'INT',
                    style: contentText,
                  ),
                  Text(
                    stringMods[3],
                    style: titleStyle,
                  ),
                  Text(
                    '${postRaceASI[3]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'WIS',
                    style: contentText,
                  ),
                  Text(
                    stringMods[4],
                    style: titleStyle,
                  ),
                  Text(
                    '${postRaceASI[4]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'CHA',
                    style: contentText,
                  ),
                  Text(
                    stringMods[5],
                    style: titleStyle,
                  ),
                  Text(
                    '${postRaceASI[5]}',
                    style: contentText,
                  )
                ],
              ),
            ],
          ),
        );
      }

      Widget getFeatures() {
        List<Feature> level1Features = [];
        for (int i = 0; i < classFeatures.length; i++) {
          if (classFeatures[i].levelReq == 1) {
            level1Features.add(classFeatures[i]);
          }
        }

        return Container(
            child: Column(
              children: [
                Text(
                  'Class Features',
                  style: headerText,
                ),
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: level1Features.length,
                    itemBuilder: (BuildContext context, int index) {
                      String featureName = level1Features[index].name!;
                      return ListTile(
                        leading: const Icon(Icons.star),
                        title: Text(featureName, style: contentText,),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text(
                  'Race Features',
                  style: headerText,
                ),
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: raceFeatures.length,
                    itemBuilder: (BuildContext context, int index) {
                      String featureName = raceFeatures[index].name!;
                      return ListTile(
                        leading: const Icon(Icons.star),
                        title: Text(featureName, style: contentText,),
                      );
                    },
                  ),
                )
              ],
            )
        );
      }

      Widget rowHPAC() {
        Container widget = Container();
        //calculate AC and HP

        //HP is calculated as the class's hit dice + con mod
        int hitDie = character.charClass!.hitDie!;
        double cmod = (postRaceASI[2] - 10) / 2;
        int conMod = cmod.floor();
        log(conMod.toString());

        int HP = hitDie + conMod;

        //Character AC depends on multiple factors
        //Base AC = 10 + Dex mod
        //Need to check for unarmoured defense
        //Armour equipped also affects, but this will be added after creation, for now only base AC is shown

        //checking for unarmored defense
        bool UA = false;
        int AC = 0;
        double dmod = (postRaceASI[1] - 10) / 2;
        int dexMod = dmod.floor();

        for (Feature i in character.charClass!.featureList!) {
          if (i.name == 'Unarmored Defense') {
            UA = true;
          }
        }
        if (UA) {
          log('Unarmored Defense : True');
          AC = 10 + dexMod + conMod;
        }
        else {
          log('Unarmored Defense : False');
          AC = 10 + dexMod;
        }

        log('DEX MOD: $dexMod');
        log('CON MOD: $conMod');

        //set this hp to the character
        character.hp = HP;

        //Now build the row
        widget = Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //HP Column
              Column(
                children: [
                  const Text(
                    'HP',
                    style: headerText,
                  ),
                  const Icon(
                    Icons.favorite,
                    color: Colors.blue,
                  ),
                  Text(
                    '$HP',
                    style: contentText,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'AC',
                    style: headerText,
                  ),
                  const Icon(
                    Icons.shield,
                    color: Colors.blue,
                  ),
                  Text(
                    '$AC',
                    style: contentText,
                  ),
                ],
              ),
            ],
          ),
        );

        return widget;
      }

      Widget getSpells() {
        //iterate through the list of spells to get a string for cantrips, and a string for first level spells
        if (character.charClass!.spellcaster!) {
          String cantrips = '';
          String first = '';

          for (int i = 0; i < character.spellList!.length; i++) {
            if (character.spellList![i].level! == 'Cantrip') {
              if (cantrips == '') {
                cantrips = character.spellList![i].name!;
              }
              else {
                cantrips = '$cantrips, ${character.spellList![i].name!}';
              }
            }
            else if (character.spellList![i].level! == '1') {
              if (first == '') {
                first = character.spellList![i].name!;
              }
              else {
                first = '$first, ${character.spellList![i].name!}';
              }
            }
          }

          Widget widget = Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cantrips',
                  style: headerText,
                ),
                Text(
                  cantrips,
                  style: contentText,
                ),
                const SizedBox(height: 12),
                const Text(
                  'First Level Spells',
                  style: headerText,
                ),
                Text(
                  first,
                  style: contentText,
                ),
              ],
            ),
          );

          return widget;
        }
        else return Container();
      }

      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Race',
                      style: headerText,
                    ),
                    Text(
                      '$charRace',
                      style: contentText,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Class',
                      style: headerText,
                    ),
                    Text(
                      '$charClass',
                      style: contentText,
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
            abilityScoresRow(),
            const Divider(),
            rowHPAC(),
            const Divider(),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Class Proficiencies',
                    style: headerText,
                  ),
                  Text(
                    classProfString,
                    style: contentText,
                  ),
                  const Divider(),
                  const Text(
                    'Background Proficiencies',
                    style: headerText,
                  ),
                  Text(
                    backgroundProfString,
                    style: contentText,
                  ),
                  const Divider(),
                  const Text(
                    'Languages',
                    style: headerText,
                  ),
                  Text(
                    languages,
                    style: contentText,
                  ),
                ],
              ),
            ),
            const Divider(),
            getSpells(),
            const Divider(),
            getFeatures(),
          ],
        ),
      );
    }

    Container setName() {
      TextEditingController characterNameController = TextEditingController();

      return Container(
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'Choose a name',
              style: headerText,
            ),
            TextFormField(
              controller: characterNameController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Character Name',
                  labelStyle: contentText
              ),
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 35,
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      log('go back');
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ChooseBackground(title: 'Create a New Character', races: raceList, classes: classList, character: character, scores: abilityScores, backgrounds: backgrounds, activeChar: activeChar, backuplist: backupList,),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('BACK', style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(
                  height: 35,
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator(),),
                      );

                      log('finish character');
                      character.name = characterNameController.text.toString();
                      character.abilityScores = postRaceASI;
                      //Create an empty subclass object
                      Subclass subclass = Subclass(name: '');
                      character.subclass = subclass;
                      character.level = Level(number: 1);
                      character.currentHp = character.hp!;
                      character.profBonus = 2;
                      character.equippedArmour = 'None';
                      character.remainingHitDie = 1;
                      await FirebaseCRUD.addNewCharacter(character: character, uId: uId);
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          '${character.name!} added to characters!',
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: UserHomePage(title: 'Home Page', activeCharacter: character,),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('COMPLETE', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              characterDetails(),
              Padding(padding: const EdgeInsets.all(24), child: setName()),
            ],
          )
        ],
      ),
    );
  }
}