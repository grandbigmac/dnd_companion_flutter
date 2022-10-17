import 'dart:core';
import 'package:dnd_app_flutter/models/race.dart';

import '../models/class.dart';

class Background {
  String? name;
  List<String>? skillProf;
  List<String>? toolProf;
  List<String>? languages;
  String? description;

  Background({
    this.name,
    this.skillProf,
    this.toolProf,
    this.languages,
    this.description
  });
}