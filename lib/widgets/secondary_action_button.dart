import 'package:flutter/cupertino.dart';
import 'package:flutter_fight_club/material/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SecondaryActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: FightClubColors.darkGreyText, width: 2),
        ),
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: FightClubColors.darkGreyText,
          ),
        ),
      ),
    );
  }
}
