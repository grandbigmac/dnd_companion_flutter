import 'dart:developer';

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

    Widget tempHomePage() {

      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //CREATE CHARACTER BUTTON
            SizedBox(
              height: 35,
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
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('CREATE A CHARACTER', style: TextStyle(color: Colors.white),),
              ),
            ),
            const Divider(),
            SizedBox(
              height: 35,
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
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('VIEW ACTIVE CHARACTER', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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