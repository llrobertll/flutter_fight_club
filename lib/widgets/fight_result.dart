import 'dart:ui';

import 'package:flutter_fight_club/resources/fight_club_colors.dart';


class FightResult {
  final String result;
  /// Добавили параметр Color чтобы добавить цвет
  final Color color;

  const FightResult._(this.result, this.color);

  /// Добавляем цвет
  static const won = FightResult._("Won", FightClubColors.green);
  static const lost = FightResult._("Lost", FightClubColors.red);
  static const draw = FightResult._("Draw", FightClubColors.blueButton);

  /// Добавляем список из тех значений который у нас может принимать FightResult
  static const values = [draw, lost, won];

  /// Создаем статический метод в котором к которому можно обращаться
  /// и передаем внутерь name который мы получили в Shared Preference
  /// и даем указание найти в списке первый попавшиеся элемент
  /// у которого result равен имени по которому мы ищем
  static FightResult getByName (final String name) {
    return values.firstWhere((fightResult) => fightResult.result == name);
  }

  static FightResult? calculateResult(final int yourLives,
      final int enemysLives) {
    if (yourLives == 0 && enemysLives == 0) {
      return draw;
    } else if (yourLives == 0) {
      return lost;
    } else if (enemysLives == 0) {
      return won;
    }
    return null;
  }

  @override
  String toString() {
    return "FightResult{result: $result}";
  }
}