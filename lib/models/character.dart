import 'dart:core';
import 'package:dnd_app_flutter/models/race.dart';
import 'package:dnd_app_flutter/models/subclass.dart';

import '../models/class.dart';
import 'background.dart';
import 'level.dart';

class Character {
  String? name;
  int? hp;
  Level? level;
  Class? charClass;
  Race? race;
  Subclass? subclass;
  List<int>? abilityScores;
  Background? background;
  List<String>? proficiencies;
  List<String>? languages;
  List<String>? toolProfs;
  int? profBonus;

  Character({
    this.name,
    this.hp,
    this.level,
    this.charClass,
    this.race,
    this.subclass,
    this.abilityScores,
    this.background,
    this.proficiencies,
    this.languages,
    this.toolProfs,
    this.profBonus,
  });
}