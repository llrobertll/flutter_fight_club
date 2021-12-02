import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/widgets/fight_result.dart';
import 'package:flutter_fight_club/widgets/fight_result_widget.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}

class _MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Text(
                "The\nfight\nclub".toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: FightClubColors.darkGreyText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            FutureBuilder<String?>(
              future: SharedPreferences.getInstance().then(
                (sharedPreferences) =>
                    sharedPreferences.getString("last_fight_result"),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                }

                /// Если есть данные в snapshot.data тогда возвращаем колонку
                /// с текстом и наш виджет (FightResultWidget) и передаем параметры
                /// fightResult - мы получили и переобразовали из имени который
                /// мы получили в Shared Preference в объект fightResult и этот
                /// объект передали в виджет FightResult
                final FightResult fightResult =
                    FightResult.getByName(snapshot.data!);
                return Column(
                  children: [
                    const SizedBox(child: Text("Last fight result")),
                    const SizedBox(height: 12),
                    FightResultWidget(fightResult: fightResult),
                  ],
                );
              },
            ),
            const Expanded(child: SizedBox()),
            SecondaryActionButton(
              text: "Statistics",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StatisticsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ActionButton(
              text: "Start".toUpperCase(),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FightPage(),
                  ),
                );
              },
              color: FightClubColors.blackButton,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
