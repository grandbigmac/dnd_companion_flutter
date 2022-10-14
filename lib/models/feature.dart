import 'dart:core';
import 'package:dnd_app_flutter/models/race.dart';

import '../models/class.dart';

class Feature {
  String? name;
  String? effect;
  int? levelReq;

  Feature({
    this.name,
    this.effect,
    this.levelReq,
  });
}