import 'dart:core';

import 'package:dnd_app_flutter/models/spell.dart';

import 'feature.dart';

class Class {
  String? name;
  String? description;
  int? hitDie;
  int? skillCount;
  bool? spellcaster;
  String? savingthrows;
  List<Feature>? featureList;
  List<String>? armourProfs;
  List<String>? weaponProfs;
  List<String>? toolProfs;
  List<Spell>? spellList;
  List<String>? spellCount;

  Class({
    this.name,
    this.featureList,
    this.description,
    this.hitDie,
    this.spellcaster,
    this.savingthrows,
    this.skillCount,
    this.armourProfs,
    this.weaponProfs,
    this.toolProfs,
    this.spellList,
    this.spellCount,
  });
}