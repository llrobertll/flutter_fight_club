/// Перенесли целый клас в отдельный ДартФайл
/// Будут ошибки гужно просто добавить импорты "material"
/// В Main тоже

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/material/fight_club_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: FightClubColors.whiteText,
          ),
        ),
      ),
    );
  }
}