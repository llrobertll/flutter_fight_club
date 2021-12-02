import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/fight_result.dart';

class FightResultWidget extends StatelessWidget {
  final FightResult fightResult;


  const FightResultWidget({
    Key? key,
    required this.fightResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
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
              /// Делаем виджет
              /// Передаем цвет с виджета FightResult
              /// И текст который получаем с виджета FightResult
              Container(
                decoration: ShapeDecoration(
                  color: fightResult.color,
                  shape: const StadiumBorder(),
                ),
                height: 44,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  /// Передаем текст
                  child: Text(
                    fightResult.result.toLowerCase(),
                    style: const TextStyle(
                      color: FightClubColors.whiteText,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
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
            ],
          ),
        ],
      ),
    );
  }
}
