import 'package:flutter/material.dart';
import 'package:flutter_fight_club/material/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: const Text(
                "Statistics",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                }
                final SharedPreferences sp = snapshot.data!;
                return Column(
                  children: [
                    Text(
                      "Won ${sp.getInt("stats_won") ?? 0}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: FightClubColors.darkGreyText
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Lost ${sp.getInt("stats_lost") ?? 0}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: FightClubColors.darkGreyText
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Draw ${sp.getInt("stats_draw") ?? 0}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: FightClubColors.darkGreyText
                      ),
                    ),
                  ],
                );
              },
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SecondaryActionButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                text: "Back",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
