import 'dart:math' as math;

class Helper {
  static int randomInt(int min, int max) {
    var rng = new math.Random();
    return rng.nextInt(max + 1 - min) + min;
  }
}