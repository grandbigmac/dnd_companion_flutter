import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_app_flutter/models/character.dart';
import 'package:dnd_app_flutter/models/level.dart';
import 'package:dnd_app_flutter/models/subclass.dart';
import 'package:dnd_app_flutter/models/user.dart';

import '../models/class.dart';
import '../models/feature.dart';
import '../models/race.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('jobs');

class FirebaseCRUD {

  static Future<List<Race>> getRaces() async {
    List<Race> races = [];
    races.add(Race(name: '--'));

    //Query for races
    final querySnapshotRace = await FirebaseFirestore.instance.collection('races').get();

    for (var doc in querySnapshotRace.docs) {
      String raceName = doc.get('name');
      String asi = doc.get('asi');
      String languages = doc.get('languages');
      String description = doc.get('description');
      int speed = doc.get('speed');

      List<Feature> raceFeatures = [];

      final featureQuery = await FirebaseFirestore.instance.collection('races').doc(doc.id).collection('features').get();
      for (var doc in featureQuery.docs) {
        String name = doc.get('name');
        String effect = doc.get('effect');
        String source = doc.get('source');

        raceFeatures.add(Feature(name: name, effect: effect, source: source));
      }


      races.add(Race(name: raceName, asi: asi, languages: languages, speed: speed, featureList: raceFeatures, description: description));
    }

    return races;
  }

  static Future<List<Class>> getClasses() async {
    List<Class> classes = [];
    classes.add(Class(name: '--'));

    //Query for races
    final querySnapshotClass = await FirebaseFirestore.instance.collection('classes').get();

    for (var doc in querySnapshotClass.docs) {
      String className = doc.get('name');
      String description = doc.get('description');

      List<Feature> classFeatures = [];

      final featureQuery = await FirebaseFirestore.instance.collection('classes').doc(doc.id).collection('features').get();
      for (var doc in featureQuery.docs) {
        String name = doc.get('name');
        String effect = doc.get('effect');
        String source = doc.get('source');
        int levelReq = doc.get('levelReq');

        classFeatures.add(Feature(name: name, effect: effect, source: source, levelReq: levelReq));
      }


      classes.add(Class(name: className, featureList: classFeatures, description: description));
    }

    return classes;
  }



  static Future<Character> getCharacter(String uId) async {
    int level;

    String characterString;
    String raceString;
    String classString;
    String subclassString;

    List data = [];
    List<Feature> featureList = [];

    Character character = Character();
    Race race = Race();
    Class charClass = Class();
    Subclass subClass = Subclass();
    Feature feature = Feature();
    Level charLevel = Level();

    //START FROM LEAST COMPLEXITY ON CLASSES TO BUILD OUT EACH OBJECT
    final snapshotUser = await FirebaseFirestore.instance.collection('users').where('uId', isEqualTo: uId).get();
    characterString = snapshotUser.docs.first['activeCharacter'];

    final snapshotCharacter = await FirebaseFirestore.instance.collection('characters').doc(characterString).get();
    classString = snapshotCharacter['class'];
    raceString = snapshotCharacter['race'];
    subclassString = snapshotCharacter['subclass'];

    final snapshotRace = await FirebaseFirestore.instance.collection('races').doc(raceString).get();

    //Get character Level
    level = await snapshotCharacter['level'];

    final snapshotClass = await FirebaseFirestore.instance.collection('classes').doc(classString).get();

    featureList = await getFeatures(subclassString, classString, raceString, level);
    for (Feature i in featureList) {
      log(i.name!);
    }

    charLevel = Level(
        number: level,
        featureList: featureList);

    subClass = Subclass(name: subclassString, levels: charLevel);

    //Create race object
    race = Race(
        name: snapshotRace['name'],
        speed: snapshotRace['speed'],
        asi: snapshotRace['asi'],
        languages: snapshotRace['languages'],
    );

    //Create class object
    charClass = Class(name: snapshotClass['name'], description: snapshotClass['description']);

    //Create Character object
    character = Character(
        name: snapshotCharacter['name'],
        charClass: charClass,
        race: race,
        level: charLevel,
        subclass: subClass
    );

    return character;
  }

  static Future<List<Feature>> getFeatures(String subclassString, String classString, String raceString, int level) async {
    List<Feature> featureList = [];

    //Query for race features
    final querySnapshotRace = await FirebaseFirestore.instance.collection('races')
        .doc(raceString).collection('features').get();

    for (var doc in querySnapshotRace.docs) {
      String name = doc.get('name');
      String effect = doc.get('effect');
      String source = doc.get('source');

      featureList.add(Feature(name: name, effect: effect, source: source));
    }

    log((level+1).toString());
    //Query for class features
    final querySnapshotClass = await FirebaseFirestore.instance.collection('classes')
        .doc(classString).collection('features').where('levelReq', isLessThanOrEqualTo: level).get();

    for (var doc in querySnapshotClass.docs) {
      String name = doc.get('name');
      String effect = doc.get('effect');
      int levelReq = doc.get('levelReq');
      String source = doc.get('source');

      featureList.add(Feature(name: name, effect: effect, levelReq: levelReq, source: source));
    }

    //Query for subclass features
    final querySnapshotSubclass = await FirebaseFirestore.instance.collection('subclasses')
        .doc(subclassString).collection('features').where('levelReq', isLessThanOrEqualTo: level).get();

    for (var doc in querySnapshotSubclass.docs) {
      String name = doc.get('name');
      String effect = doc.get('effect');
      int levelReq = doc.get('levelReq');
      String source = doc.get('source');

      featureList.add(Feature(name: name, effect: effect, levelReq: levelReq, source: source));
    }

    return featureList;
  }
}