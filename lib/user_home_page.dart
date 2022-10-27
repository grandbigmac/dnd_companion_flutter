import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_app_flutter/character_creation/choose_race.dart';
import 'package:dnd_app_flutter/login_register/login.dart';
import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/style/textstyles.dart';
import 'package:dnd_app_flutter/view_active_character/character_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'models/character.dart';
import 'models/class.dart';
import 'models/feature.dart';
import 'models/level.dart';
import 'models/race.dart';
late Character activeCharacter;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.title, required this.activeCharacter});
  final String title;
  final Character activeCharacter;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  List<Character> tempCharacterList = [];
  List<String> charNames = [];
  List<Widget> drawerWidgets = [];

  void charList() async {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    charNames = await FirebaseCRUD.getCharacterList(uId);
    for (String i in charNames) {
      log(i);
    }
    getCharacterListDetails();
  }

  void getCharacterListDetails() async {

    for (String i in charNames) {
      var data = await FirebaseFirestore.instance.collection('characters').doc(i).get();
      String raceString = data.get('race');
      String classString = data.get('class');
      List<String> raceclassnames = await FirebaseCRUD.getClassAndRaceName(classString, raceString);
      Character previewChar = Character(name: data.get('name'), charClass: Class(name: raceclassnames[0]), race: Race(name: raceclassnames[1]), level: Level(number: data.get('level')));

      tempCharacterList.add(previewChar);
    }
    for (Character i in tempCharacterList) {
      log('Name: ${i.name!}');
      log('Class: ${i.charClass!.name!}');
      log('Race: ${i.race!.name!}');
      log('Level: ${i.level!.number!}');
    }

    characterInformationList();
  }

  void characterInformationList() {

    for (int j = 0; j < tempCharacterList.length; j++) {
      Character i = tempCharacterList[j];

      Widget widget = ListTile(
        leading: const Icon(Icons.account_circle, color: Colors.blue, size: 40,),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name', style: headerText,),
                    Text(i.name!, style: contentText,),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Race', style: headerText),
                    Text(i.race!.name!, style: contentText,),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Class', style: headerText),
                    Text(i.charClass!.name!, style: contentText),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Level', style: headerText),
                    Text(i.level!.number!.toString(), style: contentText),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator(),),
                      );
                      log('Attempting');
                      await FirebaseCRUD.updateActiveCharacter(
                        charNames[j], FirebaseAuth.instance.currentUser!.uid,);
                      Character char = await FirebaseCRUD.getCharacter(FirebaseAuth.instance.currentUser!.uid);
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: UserHomePage(title: 'Home', activeCharacter: char,),
                            inheritTheme: true,
                            ctx: context),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'Something went wrong!\n$e',
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Make Active Character', style: headerText,),
                )
              ],
            ),
            const Divider(),
          ],
        ),
      );
      drawerWidgets.add(widget);
    }
  }

  @override
  void initState() {
    charList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    activeCharacter = widget.activeCharacter;

    void newUserCatch() {
      if (activeCharacter.name! == 'New User') {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'As a new user you gotta make a character.',
                            style: contentText,
                          ),
                        ],
                      ),
                    )
                  ],
                ),)
        );
      }
    }

    Widget buttonListViewCharacterCreation() {

      return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Character Actions',
                style: headerText,
              ),
              Container(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                        child: Column(
                          children: [
                            Container(
                              height: 140,
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () async {
                                  //Show a loading progress indicator
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => Center(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16.0),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.blue, width: 2),
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Loading Race data ...',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),),
                                  );

                                  List<Race> raceList = await FirebaseCRUD.getRaces();

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => Center(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16.0),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.blue, width: 2),
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Loading Class data ...',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),),
                                  );
                                  List<Class> classList = await FirebaseCRUD.getClasses();

                                  List<Race> backupList = [];

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: ChooseRace(title: 'Choose Race', races: raceList, classes: classList, character: Character(), activeChar: activeCharacter, backuplist: backupList,),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: Text('Create\nCharacter', style: titleStyleButton,),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              height: 140,
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () {
                                  //VIEW ACTIVE CHARACTER
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: CharacterProfile(title: 'Profile', activeChar: activeCharacter,),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: Text('View\nActive\nCharacter', style: titleStyleButton,),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      );
    }

    Widget tempHomePage() {

      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buttonListViewCharacterCreation(),
          ],
        ),
      );
    }




    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              signOut();
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const LoginPage(title: 'Log in',),
                    inheritTheme: true,
                    ctx: context),
              );
            }
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(child: Text('Character Select', style: titleStyleButton,)),
              ),
            ),
            Column(
              children: drawerWidgets,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currently active character is: ${activeCharacter.name!}',
                  style: contentText,
                ),
                const Divider(),
                tempHomePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void signOut() {
  FirebaseAuth.instance.signOut();

}