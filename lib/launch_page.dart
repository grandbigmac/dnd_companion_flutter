import 'dart:developer';

import 'package:dnd_app_flutter/services/firebaseCRUD.dart';
import 'package:dnd_app_flutter/user_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'models/character.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key, required this.title});
  final String title;

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 100,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    log('Create a New Character');
                    Character activeCharacter = await FirebaseCRUD.getCharacter('nafwPoNFAwponaf');
                    log(activeCharacter.name!);

                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: UserHomePage(title: 'Home', activeCharacter: activeCharacter,),
                          inheritTheme: true,
                          ctx: context),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/inn_create_new_character.png',
                    fit: BoxFit.fill,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}