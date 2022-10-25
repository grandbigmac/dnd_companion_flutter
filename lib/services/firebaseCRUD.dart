import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd_app_flutter/models/character.dart';
import 'package:dnd_app_flutter/models/level.dart';
import 'package:dnd_app_flutter/models/skills_languages_tools.dart';
import 'package:dnd_app_flutter/models/subclass.dart';
import 'package:dnd_app_flutter/models/user.dart';
import 'package:dnd_app_flutter/user_home_page.dart';

import '../models/background.dart';
import '../models/class.dart';
import '../models/feature.dart';
import '../models/race.dart';
import '../models/response.dart';
import '../models/spell.dart';

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
      int skillCount = doc.get('skills');
      int hitDie = doc.get('hitDie');
      bool spellcaster = doc.get('spellcaster');
      String savingthrows = doc.get('savingthrows');
      dev.log(savingthrows);

      //Get class features
      List<Feature> classFeatures = [];

      final featureQuery = await FirebaseFirestore.instance.collection('classes').doc(doc.id).collection('features').get();
      for (var doc in featureQuery.docs) {
        String name = doc.get('name');
        String effect = doc.get('effect');
        String source = doc.get('source');
        int levelReq = doc.get('levelReq');

        classFeatures.add(Feature(name: name, effect: effect, source: source, levelReq: levelReq));
      }

      //Get class weapon proficiencies
      List<String> weaponProfs = [];
      final weaponQuery = await FirebaseFirestore.instance.collection('classes').doc(doc.id).collection('weaponProfs').get();
      for (var doc in weaponQuery.docs) {
        String name = doc.get('name');
        weaponProfs.add(name);
      }

      //Get class armour proficiencies (collection might not exist)
      List<String> armourProfs = [];
      try {
        final armourQuery = await FirebaseFirestore.instance.collection('classes').doc(doc.id).collection('armourProfs').get();
        for (var doc in armourQuery.docs) {
          String name = doc.get('name');
          armourProfs.add(name);
        }
      } catch (e) {
      }

      //Get class tool proficiencies (collection might not exist)
      List<String> toolProfs = [];
      try {
        final armourQuery = await FirebaseFirestore.instance.collection('classes').doc(doc.id).collection('toolProfs').get();
        for (var doc in armourQuery.docs) {
          String name = doc.get('name');
          toolProfs.add(name);
        }
      } catch (e) {
      }

      //Get the number of cantrips this class can have at level 1
      String cantripCount = '';
      String firstLevelCount = '';
      List<String> spellCount = [];
      try {
        final cantripQuery = await FirebaseFirestore.instance.collection('classes').doc(doc.id).collection('spellcounts').get();
        for (var doc in cantripQuery.docs) {
          String level = doc.get('level');
          if (level == 'cantrip') {
            cantripCount = (doc.get('count'));
          }
          else if (level == '1') {
            firstLevelCount = (doc.get('count'));
          }
        }
      } catch (e) {
      }
      spellCount.add(cantripCount);
      spellCount.add(firstLevelCount);

      classes.add(Class(name: className, featureList: classFeatures,
          hitDie: hitDie, description: description,
          skillCount: skillCount, weaponProfs: weaponProfs,
          toolProfs: toolProfs, armourProfs: armourProfs, savingthrows: savingthrows,
          spellcaster: spellcaster, spellCount: spellCount,));
    }

    return classes;
  }

  static Future<List<Spell>> getCharacterCreationSpells(String charClass) async {
    List<Spell> spells = [];

    //GET CANTRIPS
    //////////////////////////////
    //GET ABJURATION
    final abcanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('abjuration').get();
    for (var doc in abcanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Abjuration';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }//////////////////////////////
    //GET CONJURATION
    final concanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('conjuration').get();
    for (var doc in concanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Conjuration';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET DIVINATION
    final divcanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('divination').get();
    for (var doc in divcanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Divination';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }

    }
    //GET ENCHANTMENT
    final enccanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('enchantment').get();
    for (var doc in enccanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Enchantment';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET EVOCATION
    final evocanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('evocation').get();
    for (var doc in evocanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Evocation';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET ILLUSION
    final illcanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('illusion').get();
    for (var doc in illcanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Illusion';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET NECROMANCY
    final neccanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('necromancy').get();
    for (var doc in neccanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Necromancy';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET TRANSMUTATION
    final tracanQuery = await FirebaseFirestore.instance.collection('spells').doc('cantrip').collection('transmutation').get();
    for (var doc in tracanQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = 'Cantrip';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Transmutation';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }

    //GET 1ST LEVEL SPELLS
    //////////////////////////////
    //GET ABJURATION
    final abfirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('abjuration').get();
    for (var doc in abfirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Abjuration';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }//////////////////////////////
    //GET CONJURATION
    final confirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('conjuration').get();
    for (var doc in confirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Conjuration';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET DIVINATION
    final divfirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('divination').get();
    for (var doc in divfirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Divination';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }

    }
    //GET ENCHANTMENT
    final encfirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('enchantment').get();
    for (var doc in encfirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Enchantment';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET EVOCATION
    final evofirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('evocation').get();
    for (var doc in evofirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Evocation';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET ILLUSION
    final illfirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('illusion').get();
    for (var doc in illfirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Illusion';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET NECROMANCY
    final necfirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('necromancy').get();
    for (var doc in necfirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Necromancy';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }
    //GET TRANSMUTATION
    final trafirQuery = await FirebaseFirestore.instance.collection('spells').doc('1').collection('transmutation').get();
    for (var doc in trafirQuery.docs) {
      String name = doc.id;
      String classes = doc.get('class');
      String description = doc.get('description');
      String level = '1';
      String casttime = doc.get('casttime');
      String components = doc.get('components');
      String duration = doc.get('duration');
      String range = doc.get('range');
      String school = 'Transmutation';

      if (classes.contains(charClass)) {
        spells.add(Spell(name: name, classes: classes, description: description, level: level, casttime: casttime, components: components, duration: duration, range: range, school: school));
      }
    }

    return spells;
  }

  static Future<Response> addNewCharacter({
    required Character character,
    required String uId,
  }) async {
    //GET THE CHARACTER, RACE AND BACKGROUND STRINGS FROM THEIR DOC ID'S
    String raceString = '', classString = '', backgroundString = '';

    await FirebaseFirestore.instance.collection('races').where('name', isEqualTo: character.race!.name).get().then((value) {
      for (var i in value.docs) {
        raceString = i.id;
      }
    });
    await FirebaseFirestore.instance.collection('classes').where('name', isEqualTo: character.charClass!.name).get().then((value) {
      for (var i in value.docs) {
        classString = i.id;
      }
    });
    await FirebaseFirestore.instance.collection('backgrounds').where('name', isEqualTo: character.background!.name).get().then((value) {
      for (var i in value.docs) {
        backgroundString = i.id;
      }
    });

    String abilityScores = character.abilityScores![0].toString() + ',' +
        character.abilityScores![1].toString() + ',' +
        character.abilityScores![2].toString() + ',' +
        character.abilityScores![3].toString() + ',' +
        character.abilityScores![4].toString() + ',' +
        character.abilityScores![5].toString();

    //Create the list of skill proficiencies held by this character
    String proficiencies = '';
    List<String> profListSkills = [];

    List<String> backgroundProfsSkills = character.background!.skillProf!;
    for(String i in backgroundProfsSkills) {
      profListSkills.add(i);
    }
    List<String> classProfsSkills = character.proficiencies!;
    for (String i in classProfsSkills) {
      if (!profListSkills.contains(i)){
        profListSkills.add(i);
      }
      //COULD PROMPT HERE TO SELECT ANOTHER IF THERE ARE DUPLICATES
    }

    for (int i = 0; i < profListSkills!.length; i++) {
      if (i == 0) {
        proficiencies = profListSkills[i];
      } else {
        proficiencies = '$proficiencies,${profListSkills[i]}';
      }
    }


    //Create the list of language proficiencies held by this character
    String proficienciesLang = '';
    List<String> profListLang = [];

    List<String> backgroundProfsLang = character.background!.languages!;
    for(String i in backgroundProfsLang) {
      if (!profListLang.contains(i)){
        profListLang.add(i);
      }
      //COULD PROMPT HERE TO SELECT ANOTHER IF THERE ARE DUPLICATES
    }

    for (int i = 0; i < profListLang!.length; i++) {
      if (i == 0) {
        proficienciesLang = profListLang[i];
      } else {
        proficienciesLang = '$proficienciesLang,${profListLang[i]}';
      }
    }

    //Create the list of tool proficiencies held by this character
    String proficienciesTool = '';
    List<String> profListTool = [];

    List<String> backgroundProfsTool = character.background!.toolProf!;
    for(String i in backgroundProfsTool) {
      if (!profListTool.contains(i)){
        profListTool.add(i);
      }
      //COULD PROMPT HERE TO SELECT ANOTHER IF THERE ARE DUPLICATES
    }

    for (int i = 0; i < profListTool!.length; i++) {
      if (i == 0) {
        proficienciesTool = profListTool[i];
      } else {
        proficienciesTool = '$proficienciesTool,${profListTool[i]}';
      }
    }

    int hp = character.hp!;


    //Generate a doc id
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String id = String.fromCharCodes(Iterable.generate(
        10, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    Response response = Response();
    CollectionReference collection = FirebaseFirestore.instance.collection('characters');
    DocumentReference documentReference = collection.doc(id);

    updateActiveCharacter(id, uId);

    bool spellcaster = character.charClass!.spellcaster!;

    if (character.charClass!.spellcaster!){
      //Create a spelllist string from the spell list object
      String spellList = '';
      for (int i = 0; i < character.spellList!.length; i++) {
        if (i == 0) {
          spellList = character.spellList![i].name!;
        } else {
          spellList = spellList + ',' + character.spellList![i].name!;
        }
      }
      Map<String, dynamic> data = <String, dynamic>{
        'name': character.name,
        'level': 1,
        'race': raceString,
        'class': classString,
        'subclass': '',
        'remainingHitDie': 1,
        'spellcaster': spellcaster,
        'abilityScores': abilityScores,
        'background': backgroundString,
        'proficiencies': proficiencies,
        'toolProfs': proficienciesTool,
        'languages': proficienciesLang,
        'profBonus': 2,
        'hp': hp,
        'currentHp': hp,
        'spellList': spellList,
      };

      var result = await documentReference
          .set(data)
          .whenComplete(() {
        response.code = 200;
        response.message = 'Successfully added to firestore';
      })
          .catchError((e) {
        response.code = 500;
        response.message = e;
      });

      return response;
    }
    else {
      Map<String, dynamic> data = <String, dynamic>{
        'name': character.name,
        'level': 1,
        'race': raceString,
        'class': classString,
        'subclass': '',
        'spellcaster': spellcaster,
        'abilityScores': abilityScores,
        'background': backgroundString,
        'proficiencies': proficiencies,
        'toolProfs': proficienciesTool,
        'languages': proficienciesLang,
        'profBonus': 2,
        'hp': hp,
        'currentHP': hp,
      };

      var result = await documentReference
          .set(data)
          .whenComplete(() {
        response.code = 200;
        response.message = 'Successfully added to firestore';
      })
          .catchError((e) {
        response.code = 500;
        response.message = e;
      });

      return response;
    }



  }

  static void updateActiveCharacter(String id, String uId) async {
    final query = await FirebaseFirestore.instance.collection('users').where('uId', isEqualTo: uId).get();
    for (var doc in query.docs){
      String docId = doc.id!;
      await FirebaseFirestore.instance.collection('users').doc(docId).update({'activeCharacter': id});
    }

  }



  static Future<Character> getCharacter(String uId) async {


    int level;

    String characterString;
    String raceString;
    String classString;
    String subclassString;
    String backgroundString;

    List data = [];
    List<Feature> featureList = [];

    Character character = Character();
    Race race = Race();
    Class charClass = Class();
    Subclass subClass = Subclass();
    Feature feature = Feature();
    Level charLevel = Level();
    Background background = Background();

    //START FROM LEAST COMPLEXITY ON CLASSES TO BUILD OUT EACH OBJECT
    final snapshotUser = await FirebaseFirestore.instance.collection('users').where('uId', isEqualTo: uId).get();
    characterString = snapshotUser.docs.first['activeCharacter'];

    if (characterString == 'NEW') {
      return Character(name: 'New User');
    }

    final snapshotCharacter = await FirebaseFirestore.instance.collection('characters').doc(characterString).get();
    classString = snapshotCharacter['class'];
    raceString = snapshotCharacter['race'];
    subclassString = snapshotCharacter['subclass'];
    backgroundString = snapshotCharacter['background'];

    final snapshotRace = await FirebaseFirestore.instance.collection('races').doc(raceString).get();

    final snapshotBackground = await FirebaseFirestore.instance.collection('backgrounds').doc(backgroundString).get();
    String bgName = snapshotBackground['name'];
    String bgDescription = snapshotBackground['description'];
    String bgLanguagesString = snapshotBackground['languages'];
    String bgSkillProfString = snapshotBackground['skillProf'];
    String bgToolProfString = snapshotBackground['toolProf'];

    //Get character Level
    level = await snapshotCharacter['level'];

    //Get character hp
    int hp = snapshotCharacter['hp'];
    int remainingHitDie = snapshotCharacter['remainingHitDie'];
    int currentHp = snapshotCharacter['currentHP'];
    int profBonus = snapshotCharacter['profBonus'];
    String proficiencies = snapshotCharacter['proficiencies'];

    final snapshotClass = await FirebaseFirestore.instance.collection('classes').doc(classString).get();

    featureList = await getFeatures(subclassString, classString, raceString, level);

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


    //Get class attributes
    String name = snapshotClass['name'];
    int hitDie = snapshotClass['hitDie'];
    int skillCount = snapshotClass['skills'];
    bool spellcaster = snapshotClass['spellcaster'];
    String savingthrows = snapshotClass['savingthrows'];
    dev.log(savingthrows);

    List<List<String>> bigList = await getClassLists(classString, snapshotClass.id);
    List<String> armourProfs = bigList[0];
    List<String> weaponProfs = bigList[1];

    //Create class object
    charClass = Class(name: name, description: snapshotClass['description'],
        featureList: featureList, hitDie: hitDie, skillCount: skillCount,
        savingthrows: savingthrows, spellcaster: spellcaster,
        armourProfs: armourProfs, weaponProfs: weaponProfs);

    //Create background object
    background = Background(
      name: bgName,
      description: bgDescription,
      languages: bgLanguagesString.split(','),
      skillProf: bgSkillProfString.split(','),
      toolProf: bgToolProfString.split(','),
    );

    //Convert ability scores string into a list
    String abilityScoresString = snapshotCharacter['abilityScores'];
    List<String> aS = abilityScoresString.split(',');
    List<int> abilityScores = [];
    for (String i in aS) {
      abilityScores.add(int.parse(i));
    }

    //To get the character's spelllist, need to query the character's spell list string
    //then iterate through and query the spells collection to build out each spell object
    //then put them into a spell list and add to the character


    //Create Character object
    character = Character(
        name: snapshotCharacter['name'],
        charClass: charClass,
        race: race,
        remainingHitDie: remainingHitDie,
        background: background,
        level: charLevel,
        subclass: subClass,
        hp: hp,
        currentHp: currentHp,
        profBonus: profBonus,
        proficiencies: proficiencies.split(','),
        abilityScores: abilityScores,
    );

    return character;
  }

  static Future<List<List<String>>> getClassLists(String classString, String docId) async {
    List<String> armourProfs = [];
    List<String> weaponProfs = [];

    final queryArmour = await FirebaseFirestore.instance.collection('classes').doc(docId).collection('armourProfs').get();
    for (var doc in queryArmour.docs) {
      armourProfs.add(doc.get('name'));
    }
    final queryWeapon = await FirebaseFirestore.instance.collection('classes').doc(docId).collection('weaponProfs').get();
    for (var doc in queryWeapon.docs) {
      weaponProfs.add(doc.get('name'));
    }

    return [armourProfs,weaponProfs];
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

    if (subclassString != ''){
      //Query for subclass features
      final querySnapshotSubclass = await FirebaseFirestore.instance
          .collection('subclasses')
          .doc(subclassString)
          .collection('features')
          .where('levelReq', isLessThanOrEqualTo: level)
          .get();

      for (var doc in querySnapshotSubclass.docs) {
        String name = doc.get('name');
        String effect = doc.get('effect');
        int levelReq = doc.get('levelReq');
        String source = doc.get('source');

        featureList.add(Feature(
            name: name, effect: effect, levelReq: levelReq, source: source));
      }
    }

    return featureList;
  }

  static Future<List<Background>> getBackgrounds() async {
    List<Background> backgroundList = [];

    //Query for race features
    final querySnapshotRace = await FirebaseFirestore.instance.collection('backgrounds').get();

    for (var doc in querySnapshotRace.docs) {
      String name = doc.get('name');
      String description = doc.get('description');
      List<String> skillProfs = doc.get('skillProf').split(',');
      List<String> toolProfs = doc.get('toolProf').split(',');
      List<String> languages = doc.get('languages').split(',');

      backgroundList.add(Background(name: name, skillProf: skillProfs, toolProf: toolProfs, languages: languages, description: description));
    }


    return backgroundList;
  }

  static Future<Response> addNewUser({
    required User user,
  }) async {

    Response response = Response();
    CollectionReference collection = FirebaseFirestore.instance.collection('users');
    DocumentReference documentReference = collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      'name': user.name!,
      'characters': user.characters!,
      'uId': user.uId!,
      'activeCharacter': 'NEW',
    };

    var result = await documentReference
        .set(data)
        .whenComplete(() {
      response.code = 200;
      response.message = 'Successfully added to firestore';
    })
        .catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}