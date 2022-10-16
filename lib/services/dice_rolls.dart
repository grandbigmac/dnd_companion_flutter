import 'dart:math';

import '../models/class.dart';

int rollD100() {
  var rng = Random();
  int result = rng.nextInt(100);

  return result + 1;
}

int rollD20() {
  var rng = Random();
  int result = rng.nextInt(20);

  return result + 1;
}

int rollD12() {
  var rng = Random();
  int result = rng.nextInt(12);

  return result + 1;
}

int rollD10() {
  var rng = Random();
  int result = rng.nextInt(10);

  return result + 1;
}

int rollD8() {
  var rng = Random();
  int result = rng.nextInt(8);

  return result + 1;
}

int rollD6() {
  var rng = Random();
  int result = rng.nextInt(6);

  return result + 1;
}

int rollD4() {
  var rng = Random();
  int result = rng.nextInt(4);

  return result + 1;
}

int roll4D4Drop1() {
  List<int> numbers = [];
  for (int i = 0; i < 4; i++) {
    numbers.add(rollD6());
  }
  numbers.sort();
  numbers.removeAt(0);

  int result = 0;
  for (int i = 0; i < numbers.length; i++) {
    result = result + numbers[i];
  }

  return result;
}