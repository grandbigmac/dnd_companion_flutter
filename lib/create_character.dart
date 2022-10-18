import 'dart:core';
import 'dart:developer';

import 'package:dnd_app_flutter/services/dice_rolls.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'models/background.dart';
import 'models/character.dart';
import 'models/class.dart';
import 'models/feature.dart';
import 'models/race.dart';
import 'models/skills_languages_tools.dart' as sk;

TextStyle titleStyle = const TextStyle(
  color: Colors.blue,
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

//CHOOSE A RACE
class CreateCharacter extends StatefulWidget {
  const CreateCharacter({super.key, required this.title, required this.races, required this.classes, required this.character});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;

  @override
  State<CreateCharacter> createState() => _ChooseRaceState();
}
class _ChooseRaceState extends State<CreateCharacter> {
  String selectedRace = '--';
  Race charRace = Race(name: '--');
  String abilityChoice = 'STR';
  String newASI = '';
  List<String> options = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];

  @override
  Widget build(BuildContext context) {
    List<Race> raceList = widget.races;
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
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: CreateCharacter2(title: 'Create a New Character', races: raceList, classes: classList, character: character,),
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

//CHOOSE A CLASS
class CreateCharacter2 extends StatefulWidget {
  const CreateCharacter2({super.key, required this.title, required this.races, required this.classes, required this.character});
final String title;
final List<Race> races;
final List<Class> classes;
final Character character;

@override
State<CreateCharacter2> createState() => _ChooseClassState();
}
class _ChooseClassState extends State<CreateCharacter2> {
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
                                  log('go back');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: CreateCharacter(title: 'Create a New Character', races: raceList, classes: classList, character: character,),
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

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: CreateCharacter3(title: 'Create a New Character', races: raceList, classes: classList, character: character,),
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

//CHOOSE ABILITY SCORES
class CreateCharacter3 extends StatefulWidget {
  const CreateCharacter3({super.key, required this.title, required this.races, required this.classes, required this.character});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;

  @override
  State<CreateCharacter3> createState() => _ChooseAbilityScores();
}
class _ChooseAbilityScores extends State<CreateCharacter3> {

  List<int> scores = [10, 10, 10, 10, 10, 10];
  List<int> modifiers = [0, 0, 0, 0, 0, 0];
  int result = 0;
  List<String> scoreNames = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];
  String selectedScore = 'STR';


  @override
  Widget build(BuildContext context) {
    Character character = widget.character;
    List<Race> raceList = widget.races;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            child: CreateCharacter2(title: 'Create a New Character', races: raceList, classes: classList, character: character,),
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
                            child: CreateCharacter5(title: 'Create a New Character', races: raceList, classes: classList, character: character, scores: scores, backgrounds: backgroundList,),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('CONTINUE', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
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
              buttonRow(),
            ],
          )
        ],
      )
    );
  }
}

//CHOOSE BACKGROUND AND PROFICIENCIES
class CreateCharacter5 extends StatefulWidget {
  const CreateCharacter5({super.key, required this.title, required this.races, required this.classes, required this.character, required this.scores, required this.backgrounds});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;
  final List<int> scores;
  final List<Background> backgrounds;

  @override
  State<CreateCharacter5> createState() => _ChooseBackgroundAndProficiencies();
}
class _ChooseBackgroundAndProficiencies extends State<CreateCharacter5> {

  String selectedBackground = '--';
  String selectedTool1 = '--';
  bool st1 = false;
  String selectedTool2 = '--';
  bool st2 = false;
  String selectedSkill1 = '--';
  bool ss1 = false;
  String selectedSkill2 = '--';
  bool ss2 = false;
  String selectedLanguage1 = '--';
  bool sl1 = false;
  String selectedLanguage2 = '--';
  bool sl2 = false;

  @override
  Widget build(BuildContext context) {
    Character character = widget.character;
    List<Background> backgroundList = widget.backgrounds;
    List<Race> raceList = widget.races;
    List<Class> classList = widget.classes;
    List<int> scores = widget.scores;
    Background chosenBackground = Background(name: '');

    Widget buttonRow() {
      //set the strings for tool, skill, and language
      //SKILLS

      return Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            child: CreateCharacter3(title: 'Create a New Character', races: raceList, classes: classList, character: character,),
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
                      if (chosenBackground.name == '') {
                        SnackBar snackBar = const SnackBar(
                          content: Text(
                            'Select a valid background!',
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      List<bool> booleans = [ss1, ss2, st1, st2, sl1, sl2];
                      List<String> values = [selectedSkill1, selectedSkill2, selectedTool1, selectedTool2, selectedLanguage1, selectedLanguage2];
                      for (int i = 0; i < booleans.length; i++) {
                        if (booleans[i]) {
                          if (values[i] == '--') {
                            SnackBar snackBar = const SnackBar(
                              content: Text(
                                '-- is not a valid skill!',
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                        }
                      }
                      //Now, clear the background's proficiencies where there is a ? and build the chosen options
                      List<String> skill = [];
                      List<String> tool = [];
                      List<String> lang = [];
                      for (int i = 0; i < chosenBackground.skillProf!.length; i++) {
                        if (chosenBackground.skillProf![i] != '?') {
                          skill.add(chosenBackground.skillProf![i]);
                        }
                      }
                      for (int i = 0; i < chosenBackground.languages!.length; i++) {
                        if (chosenBackground.languages![i] != '?') {
                          lang.add(chosenBackground.languages![i]);
                        }
                      }
                      for (int i = 0; i < chosenBackground.toolProf!.length; i++) {
                        if (chosenBackground.toolProf![i] != '?') {
                          tool.add(chosenBackground.toolProf![i]);
                        }
                      }
                      //replace the background's proficiencies with the new list
                      chosenBackground.skillProf = skill;
                      chosenBackground.toolProf = tool;
                      chosenBackground.languages = lang;

                      for (int i = 0; i < booleans.length; i++) {
                        if (booleans[i]) {
                          if (i == 0 || i == 1) {
                            chosenBackground.skillProf!.add(values[i]);
                          }
                          else if (i == 2 || i == 3) {
                            chosenBackground.toolProf!.add(values[i]);
                          }
                          else if (i == 4 || i == 5) {
                            chosenBackground.languages!.add(values[i]);
                          }
                        }
                      }

                      character.background = chosenBackground;
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: CreateCharacter4(title: 'Create a New Character', races: raceList, classes: classList, character: character, scores: scores, backgrounds: backgroundList,),
                            inheritTheme: true,
                            ctx: context),
                      );
                    },
                    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('CONTINUE', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Column dropDownBackground() {
      List<String> backgroundNames = [];
      backgroundNames.add('--');
      for (Background i in backgroundList) {
        backgroundNames.add(i.name!);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Background',
            style: headerText,
          ),
          DropdownButton(
            isExpanded: true,
            value: selectedBackground,
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
                selectedBackground = value!;
              });
            },
            items: backgroundNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      );
    }

    Widget dd(String type, int count, List<String> content) {
      Widget widget = Container();
      List<String> currentProfs = character.proficiencies!;

      if (type == 'skill') {
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
                  if (value == selectedSkill2 || currentProfs.contains(value)) {
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
                  if (value == selectedSkill1 || currentProfs.contains(value)) {
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
      }
      else if (type == 'tool') {
        if (count == 1) {
          st1 = true;
          widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                isExpanded: true,
                value: selectedTool1,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                elevation: 16,
                style: contentText,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? value) {
                  log('changing state');
                  if (value == selectedTool2) {
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'This tool is already selected!',
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  setState(() {
                    log('changing state');
                    selectedTool1 = value!;
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
          st2 = true;
          widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                isExpanded: true,
                value: selectedTool2,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                elevation: 16,
                style: contentText,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? value) {
                  log('changing state');
                  if (value == selectedTool1) {
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'This tool is already selected!',
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  setState(() {
                    log('changing state');
                    selectedTool2 = value!;
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
      }
      else if (type == 'language') {
        if (count == 1) {
          sl1 = true;
          widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                isExpanded: true,
                value: selectedLanguage1,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                elevation: 16,
                style: contentText,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? value) {
                  log('changing state');
                  if (value == selectedLanguage2) {
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'This language is already selected!',
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  setState(() {
                    log('changing state');
                    selectedLanguage1 = value!;
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
          sl2 = true;
          widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                isExpanded: true,
                value: selectedLanguage2,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                elevation: 16,
                style: contentText,
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? value) {
                  log('changing state');
                  if (value == selectedLanguage1) {
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'This language is already selected!',
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  setState(() {
                    log('changing state');
                    selectedLanguage2 = value!;
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
      }
      return widget;
    }

    Widget dropDownSkill(String type, int count) {
      //get possible skills, tools and languages from the model
      List<String> skills = sk.skills;
      List<String> tools = sk.tools;
      List<String> languages = sk.languages;

      //check through the current character to eliminate proficiencies obtained
      //from the class + race
      for (int i = 0; i < languages.length; i++) {
        if (character.race!.languages!.contains(languages[i])) {
          languages.removeAt(i);
        }
      }


      Widget widget = Container();

      if (type == 'skill') {
        if (count == 1) {
          widget = dd('skill', 1,  skills);
        }
        else if (count == 2) {
          widget = dd('skill', 2, skills);
        }
      }
      else if (type == 'tool') {
        if (count == 1) {
          widget = dd('tool', 1, tools);
        }
        else if (count == 2) {
          widget = dd('tool', 2, tools);
        }
      }
      else if (type == 'language') {
        if (count == 1) {
          widget = dd('language', 1, languages);
        }
        else if (count == 2) {
          widget = dd('language', 2, languages);
        }
      }

      return widget;
    }

    Widget _pageHead = Column(
      children: [
        Text(
          'Backgrounds give your character extra proficiencies and equipment, select one from the dropdown to see what they provide.',
          style: contentText,
        ),
        Divider(),
      ],
    );

    Widget skillProficienciesWithChoices(List<String> skillProficiencies, String type) {
      for (String i in skillProficiencies) {
        log('Proficient in: $i');
      }
      if (skillProficiencies[0] == '') {
        return const Text(
          'No proficiencies for this background!',
          style: contentText,
        );
      }

      List<Widget> widgets = [];
      String currentSkills = '';
      int count = 1;

      for (int i = 0; i < skillProficiencies.length; i++){
        log(skillProficiencies[i]);
      }

      for (int i = 0; i < skillProficiencies.length; i++) {
        if (skillProficiencies[i].contains('?')) {
          Widget skillProfOption = Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a skill',
                  style: headerText,
                ),
                dropDownSkill(type, count)
              ]
            ),
          );
          widgets.add(skillProfOption);
          count++;
        }
        else {
          if (currentSkills == '') {
            currentSkills = skillProficiencies[i];
          }
          else {
            currentSkills = '$currentSkills, ${skillProficiencies[i]}';
          }
          String skill = skillProficiencies[i];
          Text content = Text(
            'You have proficiency in $skill.',
            style: contentText,
          );
          widgets.add(content);
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets
      );
    }

    Widget backgroundContent() {
      if (selectedBackground != '--') {
        for (Background i in backgroundList) {
          if (i.name == selectedBackground) {
            chosenBackground = Background(name: i.name, toolProf: i.toolProf, skillProf: i.skillProf, languages: i.languages, description: i.description);
          }
        }

        for (String i in chosenBackground.toolProf!) {
          log('Tool: $i');
        }

        String toolProficiencies = '';
        String skillProficiencies = '';
        String languages = '';
        String name = chosenBackground.name!;
        String description = chosenBackground.description!;

        //setting tool proficiency string
        for (int i = 0; i < chosenBackground.toolProf!.length; i++) {
          if (i == 0) {
            toolProficiencies = chosenBackground.toolProf![i];
          }
          else {
            toolProficiencies = '$toolProficiencies, ${chosenBackground.toolProf![i]}';
          }
        }
        //setting skill proficiency string
        for (int i = 0; i < chosenBackground.skillProf!.length; i++) {
          if (i == 0) {
            skillProficiencies = chosenBackground.skillProf![i];
          }
          else {
            skillProficiencies = '$skillProficiencies, ${chosenBackground.skillProf![i]}';
          }
        }
        //setting languages string
        for (int i = 0; i < chosenBackground.languages!.length; i++) {
          if (i == 0) {
            languages = chosenBackground.languages![i];
          }
          else {
            languages = '$languages, ${chosenBackground.languages![i]}';
          }
        }

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              skillProficienciesWithChoices(chosenBackground.skillProf!, 'skill'),
              const Divider(),
              const Text(
                'Tool Proficiencies',
                style: headerText,
              ),
              skillProficienciesWithChoices(chosenBackground.toolProf!, 'tool'),
              const Divider(),
              const Text(
                'Languages',
                style: headerText,
              ),
              skillProficienciesWithChoices(chosenBackground.languages!, 'language'),
              const Divider(),
            ],
          ),
        );
      }
      else {
        return Container();
      }
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                buttonRow(),
                const Divider(),
                _pageHead,
                dropDownBackground(),
                backgroundContent()
              ],
            ),
          )
        ],
      ),
    );
  }
}

//CHOOSE NAME AND FINALISE
class CreateCharacter4 extends StatefulWidget {
  const CreateCharacter4({super.key, required this.title, required this.races, required this.classes, required this.character, required this.scores, required this.backgrounds});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;
  final List<int> scores;
  final List<Background> backgrounds;

  @override
  State<CreateCharacter4> createState() => _ChooseNameAndReview();
}
class _ChooseNameAndReview extends State<CreateCharacter4> {
  List<int> newScores = [];


  @override
  Widget build(BuildContext context) {
    Character character = widget.character;
    //STR, DEX, CON, INT, WIS, CHA
    newScores = widget.scores;
    List<int> abilityScores = newScores;
    List<String> stringMods = [];
    List<Race> raceList = widget.races;
    List<Class> classList = widget.classes;
    List<int> scores = widget.scores;
    List<Background> backgrounds = widget.backgrounds;

    Container characterDetails() {
      String charClass = character.charClass!.name!;
      String charRace = character.race!.name!;
      List<Feature> classFeatures = character.charClass!.featureList!;
      List<Feature> raceFeatures = character.race!.featureList!;

      Widget abilityScoresRow() {
        log('it is calling atleast');

        List<String> racialIncrease = [];
        if (character.race!.asi!.contains(",")){
          racialIncrease = character.race!.asi!.split(', ');

          for (int i = 0; i < racialIncrease.length; i++) {
            int number;
            if (racialIncrease.length > 0){
              number = int.parse(racialIncrease[i][1]);

              if (racialIncrease[i].contains('STR')) {
                abilityScores[0] = abilityScores[0] + number;
                log('+STR');
              }
              else if (racialIncrease[i].contains('DEX')) {
                abilityScores[1] = abilityScores[1] + number;
                log('+DEX');
              }
              else if (racialIncrease[i].contains('CON')) {
                abilityScores[2] = abilityScores[2] + number;
                log('+CON');
              }
              else if (racialIncrease[i].contains('INT')) {
                abilityScores[3] = abilityScores[3] + number;
                log('INT');
              }
              else if (racialIncrease[i].contains('WIS')) {
                abilityScores[4] = abilityScores[4] + number;
                log('+WIS');
              }
              else if (racialIncrease[i].contains('CHA')) {
                abilityScores[5] = abilityScores[5] + number;
                log('+CHA');
              }
            }
          }
        }
        else {
          int number = int.parse(character.race!.asi![1]);
          log(number.toString());

          if (character.race!.asi!.contains('STR')) {
            abilityScores[0] = abilityScores[0] + number;
            log('+STR');
          }
          else if (character.race!.asi!.contains('DEX')) {
            abilityScores[1] = abilityScores[1] + number;
            log('+DEX');
          }
          else if (character.race!.asi!.contains('CON')) {
            abilityScores[2] = abilityScores[2] + number;
            log('+CON');
          }
          else if (character.race!.asi!.contains('INT')) {
            abilityScores[3] = abilityScores[3] + number;
            log('INT');
          }
          else if (character.race!.asi!.contains('WIS')) {
            abilityScores[4] = abilityScores[4] + number;
            log('+WIS');
          }
          else if (character.race!.asi!.contains('CHA')) {
            abilityScores[5] = abilityScores[5] + number;
            log('+CHA');
          }
        }
        log(racialIncrease.length.toString());
        log(character.race!.asi!);


        for (int i = 0; i < abilityScores.length; i++) {
          double score = abilityScores[i].toDouble();
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
                    '${abilityScores[0]}',
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
                    '${abilityScores[1]}',
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
                    '${abilityScores[2]}',
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
                    '${abilityScores[3]}',
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
                    '${abilityScores[4]}',
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
                    '${abilityScores[5]}',
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
                            child: CreateCharacter5(title: 'Create a New Character', races: raceList, classes: classList, character: character, scores: scores, backgrounds: backgrounds,),
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
                      log('finish character');
                      character.name = characterNameController.text.toString();
                      character.abilityScores = abilityScores;
                      FirebaseCRUD.addNewCharacter(character: character);
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
              SizedBox(height: 575, child: characterDetails()),
              Padding(padding: const EdgeInsets.all(24), child: setName()),
            ],
          )
        ],
      ),
    );
  }
}