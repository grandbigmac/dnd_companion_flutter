import 'dart:core';

import 'feature.dart';

class Spell {
  String? name;
  String? school;
  String? casttime;
  String? range;
  String? components;
  String? duration;
  String? description;
  String? classes;
  String? level;


  Spell({
    this.name,
    this.classes,
    this.description,
    this.level,
    this.casttime,
    this.components,
    this.duration,
    this.range,
    this.school
  });
}