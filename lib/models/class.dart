import 'dart:core';

import 'feature.dart';

class Class {
  String? name;
  String? description;
  int? hitDie;
  int? skillCount;
  List<Feature>? featureList;
  List<String>? armourProfs;
  List<String>? weaponProfs;
  List<String>? toolProfs;

  Class({
    this.name,
    this.featureList,
    this.description,
    this.hitDie,
    this.skillCount,
    this.armourProfs,
    this.weaponProfs,
    this.toolProfs
  });
}