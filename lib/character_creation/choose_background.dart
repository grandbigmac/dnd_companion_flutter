import 'dart:core';
import 'dart:developer';

import 'package:dnd_app_flutter/character_creation/review.dart';
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

//CHOOSE BACKGROUND AND PROFICIENCIES
class ChooseBackground extends StatefulWidget {
  const ChooseBackground({super.key, required this.title, required this.races, required this.classes, required this.character, required this.scores, required this.backgrounds});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;
  final List<int> scores;
  final List<Background> backgrounds;

  @override
  State<ChooseBackground> createState() => _ChooseBackgroundAndProficiencies();
}
class _ChooseBackgroundAndProficiencies extends State<ChooseBackground> {

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
                      chosenBackground = Background();
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ChooseAbilityScores(title: 'Create a New Character', races: raceList, classes: classList, character: character,),
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
                      List<String> skill = [];
                      List<String> tool = [];
                      List<String> lang = [];
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
                      for (int i = 0; i < values.length; i++) {
                        if (values[i] != '--') {
                          if (i == 0 || i == 1) {
                            skill.add(values[i]);
                            log('adding ${values[i]}');
                          }
                          else if (i == 2 || i == 3) {
                            tool.add(values[i]);
                            log('adding ${values[i]}');
                          }
                          else if (i == 4 || i == 5) {
                            lang.add(values[i]);
                            log('adding ${values[i]}');
                          }
                        }
                      }
                      //Now, clear the background's proficiencies where there is a ? and build the chosen options
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
                            child: ReviewNewCharacter(title: 'Create a New Character', races: raceList, classes: classList, character: character, scores: scores, backgrounds: backgroundList,),
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
      List<String> currentToolProfs = [];
      for (String i in character.charClass!.toolProfs!) {
        currentToolProfs.add(i);
      }
      String currentLangs = character.race!.languages!;

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
                  if (value == selectedTool2 || currentToolProfs.contains(value)) {
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
                  if (value == selectedTool1 || currentToolProfs.contains(value)) {
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
                  if (value == selectedLanguage2 || currentLangs.contains(value!)) {
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
                  if (value == selectedLanguage1 || currentLangs.contains(value!)) {
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

      //upon selecting a background we initially set all these values to false so that
      //if the user selects another background with fewer options, they won't be prevented from
      //continuing
      ss1 = false; ss2 = false; st1 = false; st2 = false; sl1 = false; sl2 = false;


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
      children: const [
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
            'You have proficiency in $skill.'.trim(),
            style: contentText,
          );
          widgets.add(content);
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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