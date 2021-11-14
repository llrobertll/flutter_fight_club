import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fight_club_images.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  /// Создаем логику что противник будет атаковать и защищать
  /// И добавляем помещаем слоучайный выбор в переменную
  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  /// Для логики добавляем три параметра
  /// И в статику выводим максимально количество жизней
  static const maxLives = 5;
  int yourLives = maxLives;
  int enemysLives = maxLives;

  String resultText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,

      /// Обернули колонку в SafeArea то есть добавили отступ от челки если она есть
      /// Использовать всегда чтобы были отступы для телефонов с челкой
      body: SafeArea(
        child: Column(
          children: [
            /// Произвели рефакторинг информации о жизнях
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),

            /// Создали по центру Виджет с максимально допустимым размером
            /// Добавили отступ со всех сторон
            /// Создал переменную чтобы добавить в нее логику
            /// Делаем логику в GoButton
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
                        resultText,
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

            /// Произвели рефакторинг кнопки "Go"
            /// OnTap вывели в функцию для удобства
            /// color оставили как есть
            GoButton(
              /// Изменяем текст в зависимости от ситуации
              text:
                  yourLives == 0 || enemysLives == 0 ? "Start new game" : "Go",
              onTap: _goButtonOnTap,
              color: _getGoButtonColor(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Создали условие при которых кнопка будет черной или серой
  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.greyButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  /// Дополнительно нужно обнулить состояние setState
  /// Чтобы на кнопку Go (New game) после конца игры можно было нажать
  void _goButtonOnTap() {
    if (yourLives == 0 || enemysLives == 0) {
      setState(() {
        yourLives = maxLives;
        enemysLives = maxLives;
      });
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        /// Добавили две переменные и кладем туда условия:
        /// Противник теряет здоровье если атака не равна защите
        /// Я теряю здоровье если защита не равна атаке противника
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool yourLoseLife = defendingBodyPart != whatEnemyAttacks;

        /// Создаем условия для потери здоровья
        /// -= это параметр присвоение (вычитаем 1 от значения)
        /// И в конце если у кого-то осталось 0 жизней то обнуляем значения до макс. кол. hp
        /// !!! Перенес на верх чтобы после последней игры не было мгновенного рестарта
        /// !!! Если оставить тогда после последней жизни игра сразу идет в рестарт
        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (yourLoseLife) {
          yourLives -= 1;
        }

        /// Делаем логику для получения результата поединка в виде текста
        if (yourLives == 0 && enemysLives != 0) {
          resultText = "You lost";
        } else if (yourLives != 0 && enemysLives == 0) {
          resultText = "You won";
        } else if (yourLives == 0 && enemysLives == 0) {
          resultText = "Draw";
        } else {
          String first = enemyLoseLife
              ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
              : "Your attack was blocked.";

          String second = yourLoseLife
              ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
              : "Enemy's attack was blocked.";

          resultText = "$first\n$second";
        }

        /// Далее нам нужно сгенерировать новые значение (Обнулить старое)
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    /// Делаем так чтобы после смерти не было возможности нажимать на кнопки
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

  /// Обернули этот класс в SizedBox по нужной высоте
  /// LivesWidget (жизни вынесли в самое начало и в самый конец)
  /// Добавили свою аватарку и врага и дали отступы
  /// Добавили зеленый бокс
  /// Заняли все пространство mainAxisAlignment.spaceAround
  @override
  Widget build(BuildContext context) {
    /// Задали высоту всему виджету FightersInfo
    return SizedBox(
      height: 160,

      /// Обернул колонку в Stack чтобы сделать для нее цвет подложки (background)
      /// Stack позволяет размещать элементы друг за другом
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              /// Занимаем все доступное место (Expanded)
              Expanded(child: ColoredBox(color: Colors.white)),
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

                  /// Добавил аватарку
                  Image.asset(FightClubImages.youAvatar, height: 92, width: 92),
                ],
              ),
              const ColoredBox(
                color: Colors.green,
                child: SizedBox(height: 44, width: 44),
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

class GoButton extends StatelessWidget {
  /// Добавляем получение текста
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  /// Делаем рефакторинг кнопки
  /// Убираем отступы, Expanded и Row
  /// GestureDetector оборачиваем в симетричный Padding (16px)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: FightClubColors.whiteText,
                ),
              ),
            ),
          ),
        ),
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
  })  

  /// Делаем проверку коректной передачи параметров (assert)
  /// Общее количество жизней должно быть не меньше или равно 1
  /// Текущее количество жижней должно быть больше или равно 0
  /// Текущее количество жижней должно быть не больше или равно общего количества жизни
  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  /// Третий вариант решения задачи:
  /// Будем возвращать список виджетов [List]
  /// Тоесть добавляем видет список в список
  /// Сначало идут сердечка а потом наше условие if
  /// И теперь у нас возвращается список виджетов
  /// И обязательно добавить лист метод expand
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

          /// метод на вход получает елемент, а потом говорит
          /// как его расскрывать внутри списка
          /// И нам нужно просто передать обратно список который мы получили
          /// И на выходе получиться один список в котором все элементы идут друг за другом
          /// .toList нужен потому что после expand нам возвращаеться int а
          /// колонка принимает обратно List
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

  /// Создаем статический список values
  /// Это все значение которые может принимать BodyPart
  static const List<BodyPart> _values = [head, torso, legs];

  /// Создаем статический метод
  /// Нам нужно получить рандомный выбор
  /// Делаем это при помощи класса Random
  /// _values.length идет от нуля до максимума
  /// 0(head), 1(torso), 2(legs)
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
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: const TextStyle(
                color: FightClubColors.darkGreyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
