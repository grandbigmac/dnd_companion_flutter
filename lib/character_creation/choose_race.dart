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
import '../user_home_page.dart';
import 'choose_class.dart';

//CHOOSE A RACE
class ChooseRace extends StatefulWidget {
  const ChooseRace({super.key, required this.title, required this.races, required this.backuplist, required this.classes, required this.character, required this.activeChar});
  final String title;
  final List<Race> races;
  final List<Race> backuplist;
  final List<Class> classes;
  final Character character;
  final Character activeChar;

  @override
  State<ChooseRace> createState() => _ChooseRaceState();
}
class _ChooseRaceState extends State<ChooseRace> {
  String selectedRace = '--';
  Race charRace = Race(name: '--');
  String abilityChoice = 'STR';
  String newASI = '';
  List<String> options = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];

  @override
  Widget build(BuildContext context) {
    Character activeChar = widget.activeChar;
    List<Race> raceList = widget.races;
    List<Race> backupList = widget.backuplist;
    List<Class> classList = widget.classes;
    Character character = widget.character;

    List<String> raceNameList = [];
    for (Race i in raceList) {
      raceNameList.add(i.name!);
    }

    void dropDownCallback(String? selectedValue) {
      if (selectedValue is String) {
        setState(() {
          abilityChoice = selectedValue;
          log('Value is now $abilityChoice');
        });
      }
    }

    DropdownButton<String> dropDownRace(List<String> list) {
      return DropdownButton(
        isExpanded: true,
        value: selectedRace,
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
            selectedRace = value!;
            for (int i = 0; i < raceList.length; i++) {
              if (raceList[i].name == selectedRace) {
                charRace = raceList[i];
              }
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

    DropdownButton<String> dropDownAbilityScore(String asi, String number) {
      if (charRace.asi!.contains!('STR')) {
        options.remove('STR');
      }
      else if (charRace.asi!.contains!('DEX')) {
        options.remove('DEX');
      }
      else if (charRace.asi!.contains!('CON')) {
        options.remove('CON');
      }
      else if (charRace.asi!.contains!('INT')) {
        options.remove('INT');
      }
      else if (charRace.asi!.contains!('WIS')) {
        options.remove('WIS');
      }
      else if (charRace.asi!.contains!('CHA')) {
        options.remove('CHA');
      }

      return DropdownButton(
        isExpanded: true,
        value: abilityChoice,
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
            setState(() {
              abilityChoice = value!;
              log('Value is now $abilityChoice');

              newASI = '$asi,+$number$abilityChoice'.substring(1);
              log(newASI);
            });
          });
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }

    Container raceInformation(Race chosenRace) {
      if (chosenRace.name != '--') {
        List<Feature> features = chosenRace.featureList!;
        String name = chosenRace.name!;
        String description = chosenRace.description!;
        String asi = chosenRace.asi!;
        List<String> asiList = [];

        if (asi.contains(',')) {
          asiList = asi.split(',');
          asi = '';
          for (int i = 0; i < asiList.length; i++) {
            if (i == 0) {
              asi = asiList[i];
            }
            else {
              asi = '$asi, ${asiList[i]}';
            }
          }
        }

        if (asi.contains('?')) {
          String number = '';
          asi = '?';

          for (int i = 0; i < asiList.length; i++) {
            if (!asiList[i].contains('?')) {
              asi = asi + asiList[i];
            }
            else {
              number = asiList[i][1];
            }
          }
          return Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              height: 600,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Race Name',
                        style: headerText,
                      ),
                      Text(
                        name,
                        style: contentText,
                      ),
                      const Divider(),
                      const Text(
                        'Ability Score Increases',
                        style: headerText,
                      ),
                      Text(
                        asi.substring(1),
                        style: contentText,
                      ),
                      const Divider(),
                      const Text(
                        'Ability Score Choice',
                        style: headerText,
                      ),
                      Text(
                        'Your race can increase one skill of your choice by $number.',
                        style: contentText,
                      ),
                      dropDownAbilityScore(asi, number),
                      const Divider(),
                      const Text(
                        'Description',
                        style: headerText,
                      ),
                      Text(
                        description,
                        style: contentText,
                      ),
                      const Divider(),
                      const Text(
                        'Features',
                        style: headerText,
                      ),
                      Container(
                        color: Colors.blue.withOpacity(0.4),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: features.map((e) {
                            String featureName = e.name!;
                            String featureEffect = e.effect!;
                            return Card(
                              child: Column(
                                children: [
                                  ExpansionTile(
                                    leading: Icon(Icons.star, color: Colors.blue,),
                                    title: Text('$featureName'),
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Effect:',
                                                style: headerText,
                                              ),
                                              Text(
                                                '$featureEffect',
                                                style: contentText,
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ],
              )
          );
        }
        else {
          newASI = asi;
          return Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              height: 600,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Race Name',
                        style: headerText,
                      ),
                      Text(
                        name,
                        style: contentText,
                      ),
                      const Divider(),
                      const Text(
                        'Ability Score Increases',
                        style: headerText,
                      ),
                      Text(
                        asi,
                        style: contentText,
                      ),
                      const Divider(),
                      const Text(
                        'Description',
                        style: headerText,
                      ),
                      Text(
                        description,
                        style: contentText,
                      ),
                      const Divider(),
                      const Text(
                        'Features',
                        style: headerText,
                      ),
                      Container(
                        color: Colors.blue.withOpacity(0.4),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: features.map((e) {
                            String featureName = e.name!;
                            String featureEffect = e.effect!;
                            return Card(
                              child: Column(
                                children: [
                                  ExpansionTile(
                                    leading: Icon(Icons.star, color: Colors.blue,),
                                    title: Text('$featureName'),
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Effect:',
                                                style: headerText,
                                              ),
                                              Text(
                                                '$featureEffect',
                                                style: contentText,
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ],
              )
          );
        }
      }
      else {
        return Container(
            height: 600,
            child: Center(
              child: const Text(
                'Select a race to have its details show here!',
                style: contentText,
              ),
            )
        );
      }
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                      child: Column(
                        children: [const Text(
                          'Select a race',
                          style: headerText,
                        ),
                          dropDownRace(raceNameList),
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
                                          type: PageTransitionType.bottomToTop,
                                          child: UserHomePage(title: 'Home Page', activeCharacter: activeChar,),
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
                                  onPressed: () {
                                    if (charRace.name == '--') {
                                      SnackBar snackBar = const SnackBar(
                                        content: Text(
                                          'Select a valid race!',
                                        ),
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      return;
                                    }
                                    //factoring in ability score choice if race with ? is chosen
                                    if (charRace.asi!.contains('?')) {
                                      charRace.asi = newASI;
                                      log(newASI);
                                    }
                                    else {
                                      charRace.asi = newASI;
                                    }
                                    character.race = charRace;

                                    //THIS WILL NEED TO BE A COPY OF RACELIST
                                    //NECESSARY FOR BACK NAVIGATION ON RACES THAT CHOOSE ABILITY SCORES
                                    List<Race> backupList = [];

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: ChooseClass(title: 'Create a New Character', races: raceList, backuprace: backupList, classes: classList, character: character, activeChar: activeChar,),
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
                        ],
                      ),
                    ),
                    raceInformation(charRace),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


