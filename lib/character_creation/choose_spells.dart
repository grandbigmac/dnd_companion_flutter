import 'dart:developer';

import 'package:dnd_app_flutter/character_creation/choose_ability_scores.dart';
import 'package:dnd_app_flutter/character_creation/choose_race.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/user_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/character.dart';
import '../models/class.dart';
import '../models/race.dart';
import '../models/spell.dart';
import '../style/textstyles.dart';
import 'choose_class.dart';

class ChooseSpells extends StatefulWidget {
  const ChooseSpells({super.key, required this.title, required this.spells, required this.races, required this.classes, required this.character, required this.activeChar, required this.backuplist});
  final String title;
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

  @override
  Widget build(BuildContext context) {
    List<Race> raceList = widget.races;
    List<Spell> spells = widget.spells;
    List<Race> backupList = widget.backuplist;
    List<Class> classList = widget.classes;
    Character character = widget.character;
    Character activeChar = widget.activeChar;

    Widget buttonRow() {

      return Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'As a ${character.charClass!.name!}, you are able to cast spells.',
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
      List<Spell> cantripList = [];
      List<Spell> firstLevelList = [];
      for (Spell i in spells) {
        if (i.level! == 'Cantrip') {
          cantripList.add(i);
        }
        else if (i.level! == '1') {
        }
      }

      Text cantripCountWidget = Text(
        '${character.charClass!.spellCount![0]} cantrips can be chosen.',
        style: contentText,
      );
      Text firstLevelCountWidget = Text(
        '${character.charClass!.spellCount![1]} first level spells can be chosen.',
        style: contentText,
      );

      Widget widget = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spells obtainable by ${character.charClass!.name!}:',
              style: headerText,
            ),
            cantripCountWidget,
            firstLevelCountWidget
          ],
        ),
      );

      return widget;
    }




    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonRow(),
            const SizedBox(height: 50,),
            spellPotentialList(),
          ],
        ),
      ),
    );
  }
}