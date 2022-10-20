import 'dart:developer';

import 'package:dnd_app_flutter/character_creation/choose_ability_scores.dart';
import 'package:dnd_app_flutter/character_creation/choose_race.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/user_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/background.dart';
import '../models/character.dart';
import '../models/class.dart';
import '../models/race.dart';
import '../models/spell.dart';
import '../style/textstyles.dart';
import 'choose_background.dart';
import 'choose_class.dart';

class ChooseSpells extends StatefulWidget {
  const ChooseSpells({super.key, required this.title, required this.scores, required this.spells, required this.races, required this.classes, required this.character, required this.activeChar, required this.backuplist});
  final String title;
  final List<int> scores;
  final List<Spell> spells;
  final List<Race> races;
  final List<Class> classes;
  final Character character;
  final Character activeChar;
  final List<Race> backuplist;

  @override
  State<ChooseSpells> createState() => _ChooseSpellsState();
}

class _ChooseSpellsState extends State<ChooseSpells> {

  Spell selectedSpell = Spell(name: '--');
  String currentCantrips = 'None selected';
  String currentFirst = 'None selected';
  List<Spell> chosenCantrips = [];
  List<Spell> chosenFirst = [];

  @override
  Widget build(BuildContext context) {
    List<Race> raceList = widget.races;
    List<Spell> spells = widget.spells;
    List<int> scores = widget.scores;
    List<Race> backupList = widget.backuplist;
    List<Class> classList = widget.classes;
    Character character = widget.character;
    Character activeChar = widget.activeChar;

    String cantripCount = character.charClass!.spellCount![0];
    String firstLevelCount = character.charClass!.spellCount![1];

    Widget buttonRow() {

      return Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'As a ${character.charClass!.name!}, you are able to cast spells.',
              style: headerText,
            ),
            SizedBox(height: 20),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ChooseAbilityScores(title: 'Create a New Character', races: raceList, classes: classList, character: character, activeChar: activeChar, backuplist: backupList,),
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
                        //SAVE SELECTED SPELLS TO THE CHARACTER
                        //Check that enough spells and cantrips have been taken
                        if (chosenCantrips.length < int.parse(cantripCount)) {
                          int current = chosenCantrips.length;
                          int remaining = int.parse(cantripCount) - current;
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'You have still have $remaining cantrips left to select!',
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        else if (chosenFirst.length < int.parse(firstLevelCount)) {
                          int current = chosenFirst.length;
                          int remaining = int.parse(firstLevelCount) - current;
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              'You still have $remaining first level spells left to select!',
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        //Combine the spell lists and add them to the character
                        List<Spell> completeList = [];
                        for(Spell i in chosenCantrips) {
                          completeList.add(i);
                        }
                        for(Spell i in chosenFirst) {
                          completeList.add(i);
                        }

                        //log the spells to confirm
                        for (Spell i in completeList) {
                          log(i.name!);
                        }

                        character.spellList = completeList;

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
            ),
            const Divider()
          ],
        ),
      );
    }

    Widget spellPotentialList() {

      if (firstLevelCount.contains('+')) {
        List<String> split = firstLevelCount.split('+');
        log(split[0]);
        log(split[1]);
        if (split[1] == 'WIS') {
          double mod = (scores[4] - 10) / 2;
          //total count of spells
          firstLevelCount = ((int.parse(split[0]) + mod.floor())).toString();
        }
      }

      Text cantripCountWidget = Text(
        '$cantripCount cantrips can be chosen.',
        style: contentText,
      );
      Text firstLevelCountWidget = Text(
        '$firstLevelCount first level spells can be chosen.',
        style: contentText,
      );

      Widget widget = Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spells obtainable by ${character.charClass!.name!}:',
              style: headerText,
            ),
            cantripCountWidget,
            firstLevelCountWidget,
            const Divider(),
            const Text(
              'Currently Selected Cantrips',
              style: headerText,
            ),
            Text(
              currentCantrips,
              style: contentText,
            ),
            const Text(
              'Currently Selected First Level Spells',
              style: headerText,
            ),
            Text(
              currentFirst,
              style: contentText,
            ),
            const Divider(),
            const Text(
              'Click the eye icon next to a spell to view its details at the bottom of the page.',
              style: contentText,
            )
          ],
        ),
      );

      return widget;
    }

    Widget spellPreviewView(Spell spell) {
      //Set a ListView window to view details of spells selected by user

      if (spell.name! != '--'){
        Widget widget = ExpansionTile(
          title: const Text('Spell Preview', style: contentText,),
          leading: const Icon(Icons.remove_red_eye, color: Colors.blue,),
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spell Preview',
                          style: headerText,
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Spell School',
                                  style: headerText,
                                ),
                                Text(
                                  spell.school!,
                                  style: contentText,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'Level',
                                  style: headerText,
                                ),
                                Text(
                                  spell.level!,
                                  style: contentText,
                                )
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Spell Name',
                                  style: headerText,
                                ),
                                Text(
                                  spell.name!,
                                  style: contentText,
                                ),
                                const Text(
                                  'Cast Time',
                                  style: headerText,
                                ),
                                Text(
                                  spell.casttime!,
                                  style: contentText,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Range',
                                  style: headerText,
                                ),
                                Text(
                                    spell.range!,
                                    style: contentText
                                ),
                                const Text(
                                    'Components',
                                    style: headerText
                                ),
                                Text(
                                  spell.components!,
                                  style: contentText,
                                ),
                                const Text(
                                  'Duration',
                                  style: headerText,
                                ),
                                Text(
                                  spell.duration!,
                                  style: contentText,
                                ),

                              ],
                            )
                          ],
                        ),
                        const Divider(),
                        const Text(
                          'Description',
                          style: headerText,
                        ),
                        Text(
                          spell.description!,
                          style: contentText,
                        )
                      ],
                    ),
                  ]
              ),
            ),
          ]
        );
        return widget;
      }
      else {
        return Container(child: Text('Select a spell to have its details appear here.', style: contentText,),);
      }
    }

    Widget chooseCantrips() {
      List<Widget> widgets = [];

      if (int.parse(cantripCount) > 0){
        for (Spell i in spells) {
          if (i.level! == 'Cantrip') {
            CheckboxListTile spellCheckBox = CheckboxListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    i.name!,
                    style: contentText,
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        selectedSpell = i;
                      });
                    },
                  )
                ],
              ),
              value: chosenCantrips.contains(i),
              onChanged: (bool? value) {
                setState(() {
                  if (value!) {
                    if (chosenCantrips.length < int.parse(cantripCount)) {
                      chosenCantrips.add(i);
                      //Recreate cantrip string for preview
                      for (int i = 0; i < chosenCantrips.length; i++) {
                        if (i == 0) {
                          currentCantrips = chosenCantrips[i].name!;
                        } else {
                          currentCantrips =
                              '$currentCantrips, ${chosenCantrips[i].name!}';
                        }
                      }
                      log('True');
                    } else {
                      log('too many in list already!');
                      SnackBar snackBar = const SnackBar(
                        content: Text(
                          'You have too many cantrips! Unselect one to select another.',
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    chosenCantrips.remove(i);
                    if (chosenCantrips.length == 0) {
                      currentCantrips = 'None selected.';
                    }
                    for (int i = 0; i < chosenCantrips.length; i++) {
                      if (i == 0) {
                        currentCantrips = chosenCantrips[i].name!;
                      } else {
                        currentCantrips =
                            '$currentCantrips, ${chosenCantrips[i].name!}';
                      }
                    }
                    log('false');
                  }
                });
              },
            );
            widgets.add(spellCheckBox);
          }
        }

        return ExpansionTile(
          title: const Text(
            'Cantrip List',
            style: contentText,
          ),
          leading: const Icon(
            Icons.bolt,
            color: Colors.blue,
          ),
          children: [
            Container(
                child: Column(
              children: widgets,
            ))
          ],
        );
      }
      else {
        return Container();
      }
    }

    Widget chooseFirstLevel() {
      List<Widget> widgets = [];

      for (Spell i in spells) {
        log('${i.name!}, ${i.level!}');
        if (i.level! == '1') {
          log('found a spell');
          CheckboxListTile spellCheckBox = CheckboxListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(i.name!, style: contentText,),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      selectedSpell = i;
                    });
                  },
                )
              ],
            ),
            value: chosenFirst.contains(i),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  if (chosenFirst.length < int.parse(firstLevelCount)){
                    chosenFirst.add(i);
                    //Recreate cantrip string for preview
                    for (int i = 0; i < chosenFirst.length; i++) {
                      if (i == 0) {
                        currentFirst = chosenFirst[i].name!;
                      }
                      else {
                        currentFirst = '$currentFirst, ${chosenFirst[i].name!}';
                      }
                    }
                    log('True');
                  }
                  else {
                    log('too many in list already!');
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'You have too many first level spells! Unselect one to select another.',
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                else {
                  chosenFirst.remove(i);
                  if (chosenFirst.length == 0) {
                    currentFirst = 'None selected.';
                  }
                  for (int i = 0; i < chosenFirst.length; i++) {
                    if (i == 0) {
                      currentFirst = chosenFirst[i].name!;
                    }
                    else {
                      currentFirst = '$currentFirst, ${chosenFirst[i].name!}';
                    }
                  }
                  log('false');
                }
              });
            },
          );
          widgets.add(spellCheckBox);
        }
      }


      return ExpansionTile(
        title: const Text('First Level Spell List', style: contentText,),
        leading: const Icon(Icons.bolt, color: Colors.blue,),
        children: [Container(child: Column(children: widgets,))],
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buttonRow(),
                const SizedBox(height: 20,),
                const Divider(),
                spellPotentialList(),
                const SizedBox(height: 20),
                chooseCantrips(),
                const Divider(),
                chooseFirstLevel(),
                const Divider(),
                spellPreviewView(selectedSpell),
              ],
            ),
          ),
        ]
      ),
    );
  }
}