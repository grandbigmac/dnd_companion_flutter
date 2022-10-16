import 'dart:core';
import '../models/class.dart';
import 'feature.dart';

class Race {
  String? name;
  String? languages;
  String? asi;
  int? speed;
  List<Feature>? featureList;
  String? description;

  Race({
    this.name,
    this.languages,
    this.asi,
    this.speed,
    this.featureList,
    this.description,
  });
}