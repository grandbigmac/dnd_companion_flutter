import 'dart:core';
import 'dart:developer';

import 'package:dnd_app_flutter/services/dice_rolls.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/style/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/background.dart';
import '../models/character.dart';
import '../models/class.dart';
import '../models/feature.dart';
import '../models/race.dart';
import '../models/skills_languages_tools.dart' as sk;
import 'choose_background.dart';
import 'choose_class.dart';


//CHOOSE ABILITY SCORES
class ChooseAbilityScores extends StatefulWidget {
  const ChooseAbilityScores({super.key, required this.title, required this.races, required this.classes, required this.character, required this.activeChar, required this.backuplist});
  final String title;
  final List<Race> races;
  final List<Race> backuplist;
  final List<Class> classes;
  final Character character;
  final Character activeChar;

  @override
  State<ChooseAbilityScores> createState() => _ChooseAbilityScores();
}
class _ChooseAbilityScores extends State<ChooseAbilityScores> {

  List<int> scores = [10, 10, 10, 10, 10, 10];
  List<int> modifiers = [0, 0, 0, 0, 0, 0];
  int result = 0;
  List<String> scoreNames = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];
  String selectedScore = 'STR';


  @override
  Widget build(BuildContext context) {
    Character activeChar = widget.activeChar;
    Character character = widget.character;
    List<Race> raceList = widget.races;
    List<Race> backupList = raceList;
    List<Class> classList = widget.classes;

    Widget scoreDisplay = Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    'STR',
                    style: contentText,
                  ),
                  Text(
                    '${modifiers[0]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${scores[0]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    'DEX',
                    style: contentText,
                  ),
                  Text(
                    '${modifiers[1]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${scores[1]}',
                    style: contentText,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 24,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    'CON',
                    style: contentText,
                  ),
                  Text(
                    '${modifiers[2]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${scores[2]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    'INT',
                    style: contentText,
                  ),
                  Text(
                    '${modifiers[3]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${scores[3]}',
                    style: contentText,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 24,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    'WIS',
                    style: contentText,
                  ),
                  Text(
                    '${modifiers[4]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${scores[4]}',
                    style: contentText,
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    'CHA',
                    style: contentText,
                  ),
                  Text(
                    '${modifiers[5]}',
                    style: titleStyle,
                  ),
                  Text(
                    '${scores[5]}',
                    style: contentText,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );


    DropdownButton<String> dropDownRace(List<String> list) {
      return DropdownButton(
        value: selectedScore,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        elevation: 16,
        style: contentText,
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (String? value) {
          log('changing state');
          setState(() {
            log('changing state');
            selectedScore = value!;

            if (selectedScore == 'STR') {
              scores[0] = result;
              double mod = result.toDouble();
              mod = (mod - 10) / 2;
              modifiers[0] = mod.floor();
            }
            else if (selectedScore == 'DEX') {
              scores[1] = result;
              double mod = result.toDouble();
              mod = (mod - 10) / 2;
              modifiers[1] = mod.floor();
            }
            else if (selectedScore == 'CON') {
              scores[2] = result;
              double mod = result.toDouble();
              mod = (mod - 10) / 2;
              modifiers[2] = mod.floor();
            }
            else if (selectedScore == 'INT') {
              scores[3] = result;
              double mod = result.toDouble();
              mod = (mod - 10) / 2;
              modifiers[3] = mod.floor();
            }
            else if (selectedScore == 'WIS') {
              scores[4] = result;
              double mod = result.toDouble();
              mod = (mod - 10) / 2;
              modifiers[4] = mod.floor();
            }
            else if (selectedScore == 'CHA') {
              scores[5] = result;
              double mod = result.toDouble();
              mod = (mod - 10) / 2;
              modifiers[5] = mod.floor();
            }
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }

    Widget rollScore() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Roll a Stat',
              style: headerText,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 35,
                  width: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        result = roll4D4Drop1();
                        log(result.toString());
                      });
                    },
                    child: const Text('Roll', style: TextStyle(color: Colors.white),),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.blue, spreadRadius: 1),
                      ]
                  ),
                  child: Text(
                    '$result',
                    style: contentText,
                  ),
                ),
                dropDownRace(scoreNames),
              ],
            ),

          ],
        ),
      );
    }

    Widget buttonRow() {

      return Container(
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'Set Ability Scores',
              style: headerText,
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        log('go back');
                        character.abilityScores = [];
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ChooseClass(title: 'Create a New Character', races: raceList, classes: classList, character: character, activeChar: activeChar, backuprace: backupList,),
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
                        log('go back');
                        for (int i = 0; i < scores.length; i++) {
                          log(scores[i].toString());
                        }

                        List<Background> backgroundList = await FirebaseCRUD.getBackgrounds();

                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ChooseBackground(title: 'Create a New Character', races: raceList, classes: classList, character: character, scores: scores, backgrounds: backgroundList, activeChar: activeChar, backuplist: backupList,),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                      child: const Text('CONTINUE', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }


    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buttonRow(),
                  const Divider(),
                  const Text(
                    'Press \'Roll\' to roll 4d6 dropping the lowest to generate an ability score, then select an ability to assign it to.',
                    style: contentText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Divider(),
                rollScore(),
                const Divider(),
                scoreDisplay,
                const Divider(),
              ],
            )
          ],
        )
    );
  }
}