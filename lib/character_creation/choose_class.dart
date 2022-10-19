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
import 'choose_ability_scores.dart';
import 'choose_race.dart';

//CHOOSE A CLASS
class ChooseClass extends StatefulWidget {
  const ChooseClass({super.key, required this.title, required this.races, required this.classes, required this.character, required this.activeChar});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;
  final Character activeChar;

  @override
  State<ChooseClass> createState() => _ChooseClassState();
}
class _ChooseClassState extends State<ChooseClass> {
  String selectedClass = '--';
  Class charClass = Class(name: '--');
  String selectedSkill1 = '--';
  bool ss1 = false;
  String selectedSkill2 = '--';
  bool ss2 = false;
  String selectedSkill3 = '--';
  bool ss3 = false;
  String selectedSkill4 = '--';
  bool ss4 = false;

  @override
  Widget build(BuildContext context) {
    Character activeChar = widget.activeChar;
    List<Race> raceList = widget.races;
    List<Class> classList = widget.classes;
    Character character = widget.character;

    List<String> classNameList = [];
    for (Class i in classList) {
      classNameList.add(i.name!);
    }

    DropdownButton<String> dropDownClass(List<String> list) {
      return DropdownButton(
        isExpanded: true,
        value: selectedClass,
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
            selectedClass = value!;
            for (int i = 0; i < classList.length; i++) {
              if (classList[i].name == selectedClass) {
                charClass = classList[i];
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

    //dropdown builders for selecting skills
    Widget dd(int count, List<String> content) {
      Widget widget = Container();

      if (count == 1) {
        ss1 = true;
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton(
              isExpanded: true,
              value: selectedSkill1,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              style: contentText,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                log('changing state');
                if (value == selectedSkill2 || value == selectedSkill3 || value == selectedSkill4) {
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      'This skill is already selected!',
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                setState(() {
                  log('changing state');
                  selectedSkill1 = value!;
                });
              },
              items: content.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        );
      }
      else if (count == 2) {
        ss2 = true;
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton(
              isExpanded: true,
              value: selectedSkill2,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              style: contentText,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                log('changing state');
                if (value == selectedSkill1 || value == selectedSkill3 || value == selectedSkill4) {
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      'This skill is already selected!',
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                setState(() {
                  log('changing state');
                  selectedSkill2 = value!;
                });
              },
              items: content.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        );
      }
      else if (count == 3) {
        ss3 = true;
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton(
              isExpanded: true,
              value: selectedSkill3,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              style: contentText,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                log('changing state');
                if (value == selectedSkill1 || value == selectedSkill2 || value == selectedSkill4) {
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      'This skill is already selected!',
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                setState(() {
                  log('changing state');
                  selectedSkill3 = value!;
                });
              },
              items: content.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        );
      }
      else if (count == 4) {
        ss4 = true;
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton(
              isExpanded: true,
              value: selectedSkill4,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              style: contentText,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                log('changing state');
                if (value == selectedSkill1 || value == selectedSkill2 || value == selectedSkill3) {
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      'This skill is already selected!',
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                setState(() {
                  log('changing state');
                  selectedSkill4 = value!;
                });
              },
              items: content.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        );
      }
      return widget;
    }

    Widget skillProficienciesWithChoices(int count) {
      List<Widget> widgets = [];
      //get possible skills, tools and languages from the model
      List<String> skills = sk.skills;

      //upon selecting a background we initially set all these values to false so that
      //if the user selects another background with fewer options, they won't be prevented from
      //continuing
      ss1 = false; ss2 = false; ss3 = false; ss4 = false;

      for (int i = 0; i < count + 1; i++) {
        widgets.add(dd(i, skills));
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets
      );
    }


    Container classInformation(Class chosenClass) {
      if (chosenClass.name != '--') {
        List<Feature> features = chosenClass.featureList!;
        String name = chosenClass.name!;
        String description = chosenClass.description!;
        String weaponString = '';
        int skillCount = chosenClass.skillCount!;
        for (int i = 0; i < chosenClass.weaponProfs!.length; i++) {
          if (i == 0) {
            weaponString = chosenClass.weaponProfs![i];
          }
          else {
            weaponString = '$weaponString, ${chosenClass.weaponProfs![i]}';
          }
        }
        String armorString = '';
        if (chosenClass.armourProfs!.isEmpty) {
          armorString = 'No armour proficiencies!';
        }
        else {
          for (int i = 0; i < chosenClass.armourProfs!.length; i++) {
            if (i == 0) {
              armorString = chosenClass.armourProfs![i];
            }
            else {
              armorString = '$armorString, ${chosenClass.armourProfs![i]}';
            }
          }
        }
        String toolString = '';
        if (chosenClass.toolProfs!.isEmpty) {
          toolString = 'No tool proficiencies!';
        }
        else {
          for (int i = 0; i < chosenClass.toolProfs!.length; i++) {
            if (i == 0) {
              toolString = chosenClass.toolProfs![i];
            }
            else {
              toolString = '$toolString, ${chosenClass.toolProfs![i]}';
            }
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
                      'Class Name',
                      style: headerText,
                    ),
                    Text(
                      name,
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
                      'Skill Proficiencies',
                      style: headerText,
                    ),
                    Text(
                      'You can choose up to $skillCount skill proficiencies.',
                      style: contentText,
                    ),
                    skillProficienciesWithChoices(skillCount),
                    const Divider(),
                    const Text(
                      'Weapon Proficiencies',
                      style: headerText,
                    ),
                    Text(
                      weaponString,
                      style: contentText,
                    ),
                    const Divider(),
                    const Text(
                      'Armor Proficiencies',
                      style: headerText,
                    ),
                    Text(
                      armorString,
                      style: contentText,
                    ),
                    const Divider(),
                    const Text(
                      'Tool Proficiencies',
                      style: headerText,
                    ),
                    Text(
                      toolString,
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
                          String levelReq = e.levelReq!.toString();
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Level Required: ',
                                                  style: headerText,
                                                ),
                                                Text(
                                                  levelReq,
                                                  style: contentText,
                                                ),
                                              ],
                                            ),
                                            const Divider(),
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
        return Container(
            height: 600,
            child: Center(
              child: const Text(
                'Select a class to have its details show here!',
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
                          'Select a class',
                          style: headerText,
                        ),
                          dropDownClass(classNameList),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 35,
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: () {
                                    character.race = Race();
                                    log('go back');
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: ChooseRace(title: 'Create a New Character', races: raceList, classes: classList, character: character, activeChar: activeChar,),
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
                                    if (charClass.name == '--') {
                                      SnackBar snackBar = const SnackBar(
                                        content: Text(
                                          'Select a valid class!',
                                        ),
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      return;
                                    }
                                    //add skill proficiency string to the character
                                    List<bool> b = [ss1, ss2, ss3, ss4];
                                    List<String> s = [selectedSkill1, selectedSkill2, selectedSkill3, selectedSkill4];
                                    List<String> profs = [];
                                    for (int i = 0; i < b.length; i++) {
                                      if (b[i]) {
                                        profs.add(s[i]);
                                      }
                                    }

                                    character.charClass = charClass;
                                    character.proficiencies = profs;

                                    for (String i in character.proficiencies!) {
                                      log(i);
                                    }

                                    List<bool> bl = [ss1, ss2, ss3, ss4];
                                    List<String> values = [selectedSkill1, selectedSkill2, selectedSkill3, selectedSkill4];
                                    for (int i = 0; i < bl.length; i++) {
                                      if (bl[i]) {
                                        if (values[i] == '--') {
                                          SnackBar snackBar = const SnackBar(
                                            content: Text(
                                              'You haven\'t selected a proficiency!',
                                            ),
                                          );

                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          return;
                                        }
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: ChooseAbilityScores(title: 'Create a New Character', races: raceList, classes: classList, character: character, activeChar: activeChar,),
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
                    classInformation(charClass),
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