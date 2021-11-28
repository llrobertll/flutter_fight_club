import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/material/fight_club_colors.dart';
import 'package:flutter_fight_club/material/fight_club_icons.dart';
import 'package:flutter_fight_club/pages/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'material/fight_club_images.dart';
import 'widgets/action_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MainPage(),
    );
  }
}


