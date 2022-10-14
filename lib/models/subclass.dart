import 'dart:core';
import 'package:dnd_app_flutter/models/race.dart';

import '../models/class.dart';
import 'level.dart';

class Subclass {
  String? name;
  List<Level>? levels;


  Subclass({
    this.name,
    this.levels,
  });
}