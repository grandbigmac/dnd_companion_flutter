import 'dart:developer';

import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'models/character.dart';
import 'models/class.dart';
import 'models/feature.dart';
import 'models/race.dart';

TextStyle titleStyle = const TextStyle(
  color: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    List<Race> raceList = widget.races;
    List<Class> classList = widget.classes;
    Character character = widget.character;

    List<String> raceNameList = [];
    for (Race i in raceList) {
      raceNameList.add(i.name!);
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

    Container raceInformation(Race chosenRace) {
      if (chosenRace.name != '--') {
        List<Feature> features = chosenRace.featureList!;
        String name = chosenRace.name!;
        String description = chosenRace.description!;

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

    Container classInformation(Class chosenClass) {
      if (chosenClass.name != '--') {
        List<Feature> features = chosenClass.featureList!;
        String name = chosenClass.name!;
        String description = chosenClass.description!;

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
                          'Select a race',
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
                                  character.charClass = charClass;
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

class CreateCharacter3 extends StatefulWidget {
  const CreateCharacter3({super.key, required this.title, required this.races, required this.classes, required this.character});
  final String title;
  final List<Race> races;
  final List<Class> classes;
  final Character character;

  @override
  State<CreateCharacter3> createState() => _ChooseNameAndReview();
}
class _ChooseNameAndReview extends State<CreateCharacter3> {


  @override
  Widget build(BuildContext context) {
    Character character = widget.character;

    Container characterDetails() {
      String charClass = character.charClass!.name!;
      String charRace = character.race!.name!;
      List<Feature> classFeatures = character.charClass!.featureList!;
      List<Feature> raceFeatures = character.race!.featureList!;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Race',
              style: headerText,
            ),
            Text(
              '$charRace',
              style: contentText,
            ),
            const Divider(),
            const Text(
              'Class',
              style: headerText,
            ),
            Text(
              '$charClass',
              style: contentText,
            ),
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
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 500, child: characterDetails()),
              Padding(padding: const EdgeInsets.all(24), child: setName()),
            ],
          )
        ],
      ),
    );
  }
}