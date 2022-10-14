import 'dart:core';
import 'package:dnd_app_flutter/models/race.dart';

import '../models/class.dart';
import '../models/feature.dart';

class Level {
  int? number;
  List<Feature>? featureList;

  Level({
    this.number,
    this.featureList,
  });
}