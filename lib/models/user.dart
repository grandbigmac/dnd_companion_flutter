import 'dart:core';
import 'package:dnd_app_flutter/models/character.dart';
import 'package:dnd_app_flutter/models/race.dart';

import '../models/class.dart';

class User {
  String? name;
  Character? activeCharacter;
  List<String>? characters;
  String? uId;


  User({
    this.name,
    this.activeCharacter,
    this.characters,
    this.uId
  });
}