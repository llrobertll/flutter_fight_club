import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/material/fight_club_colors.dart';
import 'package:flutter_fight_club/material/fight_club_icons.dart';
import 'package:flutter_fight_club/material/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/fight_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/action_button.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  FightPageState createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  static const maxLives = 5;
  int yourLives = maxLives;
  int enemysLives = maxLives;

  String centerText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: ColoredBox(
                  color: const Color(0xFFC5D1EA),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        centerText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: FightClubColors.darkGreyText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            const SizedBox(height: 14),
            ActionButton(
              text: yourLives == 0 || enemysLives == 0 ? "Back" : "Go",
              onTap: _goButtonOnTap,
              color: _getGoButtonColor(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  void _goButtonOnTap() {
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool yourLoseLife = defendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (yourLoseLife) {
          yourLives -= 1;
        }

        final FightResult? fightResult =
            FightResult.calculateResult(yourLives, enemysLives);
        if (fightResult != null) {
          SharedPreferences.getInstance().then((sharedPreferences) {
            sharedPreferences.setString("last_fight_result", fightResult.result);

            /// Добавляем возможность считать сколько раз выигрывали, проигрывали...
            /// если что-то будет в sharedPreferences тогда оставит значение но
            /// если ничего не будет тогда выводит (оставляем) 0
            /// Потом если есть значение тогда добавляем +1
            final String key = "stats_${fightResult.result}";
            final int currentValue = sharedPreferences.getInt(key) ?? 0;
            sharedPreferences.setInt(key, currentValue + 1);
          });
        }

        centerText = _calculateCenterText(yourLoseLife, enemyLoseLife);

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  /// Вынесли в метод
  String _calculateCenterText(
      final bool enemyLoseLife, final bool yourLoseLife) {
    if (yourLives == 0 && enemysLives != 0) {
      return "You lost";
    } else if (yourLives != 0 && enemysLives == 0) {
      return "You won";
    } else if (yourLives == 0 && enemysLives == 0) {
      return "Draw";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
          : "Your attack was blocked.";

      final String second = yourLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
          : "Enemy's attack was blocked.";

      return "$first\n$second";
    }
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(child: ColoredBox(color: Colors.white)),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, FightClubColors.darkPurple],
                    ),
                  ),
                ),
              ),
              Expanded(child: ColoredBox(color: FightClubColors.darkPurple)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: yourLivesCount),
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "You",
                    style: TextStyle(color: FightClubColors.darkGreyText),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, height: 92, width: 92),
                ],
              ),
              const SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: FightClubColors.blueButton,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "vs",
                      style: TextStyle(
                        color: FightClubColors.whiteText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Enemy",
                    style: TextStyle(color: FightClubColors.darkGreyText),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar,
                      height: 92, width: 92),
                ],
              ),
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: enemysLivesCount),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {Key? key,
      required this.attackingBodyPart,
      required this.defendingBodyPart,
      required this.selectDefendingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                  child: Text("Defend".toUpperCase(),
                      style: const TextStyle(
                          color: FightClubColors.darkGreyText))),
              const SizedBox(height: 16),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                  child: Text("Attack".toUpperCase(),
                      style: const TextStyle(
                          color: FightClubColors.darkGreyText))),
              const SizedBox(height: 16),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(overallLivesCount, (index) {
          if (index < currentLivesCount) {
            return [
              Image.asset(FightClubIcons.heartFull, width: 18, height: 18),
              if (index < overallLivesCount - 1) const SizedBox(height: 4),
            ];
          } else {
            return [
              Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18),
              if (index < overallLivesCount - 1) const SizedBox(height: 4),
            ];
          }
        }).expand((element) => element).toList());
  }
}

class ButtonPart {
  final String name;

  const ButtonPart._(this.name);

  static const go = ButtonPart._("Go");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;

  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors.blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                color: selected
                    ? FightClubColors.whiteText
                    : FightClubColors.darkGreyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
