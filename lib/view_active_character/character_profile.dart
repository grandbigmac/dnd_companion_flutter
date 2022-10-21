import 'dart:developer';

import 'package:dnd_app_flutter/models/skills_languages_tools.dart';
import 'package:dnd_app_flutter/style/textstyles.dart';
import 'package:dnd_app_flutter/user_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/character.dart';
import '../models/feature.dart';
import '../services/dice_rolls.dart';

class CharacterProfile extends StatefulWidget {
  const CharacterProfile({super.key, required this.title, required this.activeChar});
  final String title;
  final Character activeChar;

  @override
  State<CharacterProfile> createState() => CharacterProfilePage();
}

class CharacterProfilePage extends State<CharacterProfile> {
  bool advantage = false;
  bool disadvantage = false;

  Widget profileFloor() {


    Widget widget = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 35,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: UserHomePage(title: 'Profile', activeCharacter: activeCharacter,),
                          inheritTheme: true,
                          ctx: context),
                    );
                  },
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text('BACK', style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          )
        ],
      ),
    );

    return widget;
  }

  String getAC(int dexMod, int conMod, Character character) {
    bool UA = false;
    int AC = 0;

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

    return AC.toString();
  }

  @override
  Widget build(BuildContext context) {
    Character character = widget.activeChar;
    List<String> abilities = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];
    List<int> modifiers = [];

    Widget abilityScoresCol(int index) {
      String ability = abilities[index];
      String score = character.abilityScores![index].toString();
      double modNum = (int.parse(score) - 10) / 2;
      int modNumInt = modNum.floor();
      modifiers.add(modNumInt);
      String mod = modNumInt.toString();

      if (modNumInt < 0) {
        mod = '-$mod';
      }
      else {
        mod = '+$mod';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ability,
            style: contentText,
          ),
          Text(
            mod,
            style: titleStyle,
          ),
          Text(
            score,
            style: contentText,
          ),
          const SizedBox(height: 12)
        ],
      );
    }

    List<Widget> columns = [];

    for (int i = 0; i < abilities.length; i++) {
      columns.add(abilityScoresCol(i));
    }

    Widget abilityScoresRow = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns,
      ),
    );

    Widget acRow() {
      //Calculate AC, check for unarmored defense

      int dexMod = modifiers[1];
      int conMod = modifiers[2];
      String ac = getAC(dexMod, conMod, character);
      String speed = character.race!.speed!.toString();


      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 20,),
            Column(
              children: [
                const Icon(
                  Icons.shield,
                  color: Colors.blue,
                ),
                Text(
                  ac,
                  style: contentText,
                ),
              ],
            ),
            const SizedBox(width: 20,),
            Column(
              children: [
                const Icon(
                  Icons.bolt,
                  color: Colors.blue,
                ),
                Text(
                  dexMod.toString(),
                  style: contentText,
                ),
              ],
            ),
            const SizedBox(width: 20,),
            Column(
              children: [
                const Icon(
                  Icons.directions_run,
                  color: Colors.blue,
                ),
                Text(
                  '${speed}ft',
                  style: contentText,
                ),
              ],
            ),
            const SizedBox(width: 20,),
          ],
        ),
      );
    }

    Widget hpWidget() {


      return Container(
        width: 130,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_outline_sharp,
              color: Colors.blue,
            ),
            const SizedBox(width: 12,),
            Text(
              '${character.currentHp!} / ${character.hp!}',
              style: contentText,
            ),
          ],
        ),
      );
    }

    Widget skillRollWidget(int modifier, String skill) {
      int roll1 = 0;
      int roll2 = 0;
      int resultRoll = 0;


      Widget content = Container();

      if (advantage) {
        roll1 = rollD20() + modifier;
        roll2 = rollD20() + modifier;
        if (roll1 >= roll2) {
          resultRoll = roll1;
        }
        else {
          resultRoll = roll2;
        }

        content = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rolling $skill with advantage...',
              style: headerText,
            ),
            const SizedBox(height: 10,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      Text(
                        roll1.toString(),
                        style: titleStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      Text(
                        roll2.toString(),
                        style: titleStyle,
                      )
                    ],
                  ),
                ]

            ),
            const Divider(),
            const Text(
              'Result',
              style: headerText,
            ),
            Text(
              resultRoll.toString(),
              style: titleStyle,
            )
          ],
        );

      }
      else if (disadvantage) {
        roll1 = rollD20() + modifier;
        roll2 = rollD20() + modifier;
        if (roll2 >= roll1) {
          resultRoll = roll1;
        }
        else {
          resultRoll = roll2;
        }

        content = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rolling $skill with disadvantage...',
              style: headerText,
            ),
            const SizedBox(height: 10,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      Text(
                        roll1.toString(),
                        style: titleStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      Text(
                        roll2.toString(),
                        style: titleStyle,
                      )
                    ],
                  ),
                ]
            ),
            const Divider(),
            const Text(
              'Result',
              style: headerText,
            ),
            Text(
              resultRoll.toString(),
              style: titleStyle,
            )
          ],
        );
      }
      else {
        resultRoll = rollD20() + modifier;

        content = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rolling $skill...',
              style: headerText,
            ),
            const SizedBox(height: 10,),
            Column(
              children: const [
                Icon(
                  Icons.circle,
                  color: Colors.blue,
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Result',
              style: headerText,
            ),
            Text(
              resultRoll.toString(),
              style: titleStyle,
            )
          ],
        );
      }

      return content;
    }

    Widget skillsWithProficiencies() {
      for(String i in character.proficiencies!) {
        log('Prof bonus : $i');
      }

      List<String> skillNames = skills;
      skillNames.remove('--');
      List<int> modList = [];
      List<String> skillMods = skillMod;
      for (int i = 0; i < skillMods.length; i++) {
        String skill = skillNames[i];
        if (skillMods[i] == 'STR') {
          int mod = modifiers[0];
          if (character.proficiencies!.contains(skill)) {
            mod = mod + character.profBonus!;
          }
          modList.add(mod);
        }
        else if (skillMods[i] == 'DEX') {
          int mod = modifiers[1];
          if (character.proficiencies!.contains(skill)) {
            mod = mod + character.profBonus!;
          }
          modList.add(mod);
        }
        else if (skillMods[i] == 'CON') {
          int mod = modifiers[2];
          if (character.proficiencies!.contains(skill)) {
            mod = mod + character.profBonus!;
          }
          modList.add(mod);
        }
        else if (skillMods[i] == 'INT') {
          int mod = modifiers[3];
          if (character.proficiencies!.contains(skill)) {
            mod = mod + character.profBonus!;
          }
          modList.add(mod);
        }
        else if (skillMods[i] == 'WIS') {
          int mod = modifiers[4];
          if (character.proficiencies!.contains(skill)) {
            mod = mod + character.profBonus!;
          }
          modList.add(mod);
        }
        else if (skillMods[i] == 'CHA') {
          int mod = modifiers[5];
          if (character.proficiencies!.contains(skill)) {
            mod = mod + character.profBonus!;
          }
          modList.add(mod);
        }
      }


      //build skills with appropriate modifier with +profBonus where proficiency
      List<Widget> widgets = [];
      for (int i = 0; i < skillNames.length; i++) {
        log('${skillNames[i]}: ${modList[i]}');
        Widget widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 35,
                    width: 120,
                    child: TextButton(
                      onPressed: () {
                        for (int i in modifiers) {
                          log(i.toString());
                        }
                        //roll the skill
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        SnackBar snackBar = SnackBar(
                          content: Container(height: 140, child: skillRollWidget(modList[i], skillNames[i])),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          skillNames[i],
                          style: skillText,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ),
                  ),
                  Text(
                    modList[i].toString(),
                    style: skillModTextStyle,
                  )
                ],
              ),
            ),

          ],
        );
        widgets.add(widget);
      }

      return Container(
        width: 150,
        padding: const EdgeInsets.only(left:10, right:10),
        child: ExpansionTile(
          title: const Text('Skills', style: headerText,),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
          ]
        ),
      );
    }

    //Widget classFeaturesList() {
    //
    //}

    Widget attacksWidget() {
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
        ),
        child: const Center(
          child: Text(
            'Attacks will go here.',
            style: headerText,
          ),
        ),
      );
    }

    Widget savingThrowsWidget() {
      //modifiers
      List<int> stMods = modifiers;
      //abilities
      List<String> savingThrowProficiencies = [];

      List<Widget> savingthrows = [];

      for (int i = 0; i < abilities.length; i++) {
        if (savingThrowProficiencies.contains(abilities[i])) {
          //give it extra because proficiency

        }

        Widget widget = Container(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  //roll the skill
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    SnackBar snackBar = SnackBar(
                      content: Container(height: 140, child: skillRollWidget(modifiers[i], '${abilities[i]} saving throw')),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                child: Text(
                  abilities[i],
                  style: skillText,
                ),
              ),
              Text(
                modifiers[i].toString(),
                style: contentText,
              )
            ],
          ),
        );
        savingthrows.add(widget);
      }

      return Container(
        width: 150,
        padding: const EdgeInsets.only(left:10, right:10),
        child: ExpansionTile(
          title: const Text('Saving Throws', style: headerText,),
          children: [
            Column(
              children: savingthrows,
            )
          ]
        ),
      );
    }

    Widget advDisAdv() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_upward_sharp,
                  color: Colors.blue,
                ),
                Checkbox(
                  value: advantage,
                  onChanged: (newVal) {
                    setState(() {
                      if (disadvantage) {
                        disadvantage = false;
                      }
                      advantage = newVal!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.arrow_downward_sharp,
                  color: Colors.blue,
                ),
                Checkbox(
                  value: disadvantage,
                  onChanged: (newVal) {
                    setState(() {
                      if (advantage) {
                        advantage = false;
                      }
                      disadvantage = newVal!;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget profileContent() {
      Column subclassWidget = Column();

      if (character.subclass!.name! != '') {
        subclassWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Subclass',
              style: headerText,
            ),
            Text(
              character.subclass!.name!,
              style: contentText,
            )
          ],
        );
      }

      Widget content = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Character Name',
                      style: headerText,
                    ),
                    Text(
                      character.name!,
                      style: contentText,
                    ),
                    const Text(
                      'Race',
                      style: headerText,
                    ),
                    Text(
                      character.race!.name!,
                      style: contentText,
                    ),
                    const Text(
                      'Background',
                      style: headerText,
                    ),
                    Text(
                      character.background!.name!,
                      style: contentText,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Level',
                      style: headerText,
                    ),
                    Text(
                      character.level!.number!.toString(),
                      style: contentText,
                    ),
                    const Text(
                      'Class',
                      style: headerText,
                    ),
                    Text(
                      character.charClass!.name!,
                      style: contentText,
                    ),
                    subclassWidget,
                  ],
                ),

              ],
            ),
            const Divider(),
            //ABILITY SCORE ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                abilityScoresRow,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        acRow(),
                        advDisAdv()
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hpWidget(),
                            const Divider(),
                            skillsWithProficiencies(),
                            savingThrowsWidget()
                          ],
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            attacksWidget(),
                            const Divider(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      return content;
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                profileContent(),
                const Divider(),
                profileFloor(),
              ],
            ),
          ]
        ),
      ),
    );
  }
}