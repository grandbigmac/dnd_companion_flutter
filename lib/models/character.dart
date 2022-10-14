import 'dart:core';
import 'package:dnd_app_flutter/models/race.dart';
import 'package:dnd_app_flutter/models/subclass.dart';

import '../models/class.dart';
import 'level.dart';

class Character {
  String? name;
  Level? level;
  Class? charClass;
  Race? race;
  Subclass? subclass;

  Character({
    this.name,
    this.level,
    this.charClass,
    this.race,
    this.subclass
  });
}