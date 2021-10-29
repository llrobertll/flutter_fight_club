import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Создали две переменные чтобы понять какие элементы выделены (часть тела)
  /// Для защиты и атаки
  /// ? = null потому что на начально экране у нас ничего не виделенно
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(child: Center(child: Text("You".toUpperCase()))),
              const SizedBox(width: 12),
              Expanded(child: Center(child: Text("Enemy".toUpperCase()))),
              const SizedBox(width: 16),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      child: Text("Defend".toUpperCase()),
                    ),
                    const SizedBox(height: 13),
                    BodyPartButton(
                      bodyPart: BodyPart.head,

                      /// selected (виделить) если defendingBodyPart ровняетсья BodyPart.head
                      selected: defendingBodyPart == BodyPart.head,

                      /// Создали новую функцию и виделили её в отдельный метод
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    const SizedBox(height: 20),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: defendingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      child: Text("Attack".toUpperCase()),
                    ),
                    const SizedBox(height: 13),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: attackingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    const SizedBox(height: 20),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: attackingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ColoredBox(
                    color: const Color.fromRGBO(0, 0, 0, 0.87),
                    child: Center(
                      child: Text(
                        "Go".toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Создали новую функцию и виделили её в отдельный метод
  /// Делаем обновление состояния
  /// И говорим, что defendingBodyPart должен принимать новое значение
  void _selectDefendingBodyPart(final BodyPart value) {
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    setState(() {
      attackingBodyPart = value;
    });
  }
}

/// Используем конструктор Rich Enum
/// Чтобы иметь возможность хранить больше информации
class BodyPart {
  /// Даем ему название
  final String name;

  /// Добавляем конструктор
  const BodyPart._(this.name);

  /// Создаем два значение
  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");

  /// Дополнительно генерируем метод (код Alt+Insert) toString
  /// Чтобы легче было разрабатывать, дебажить, выводить в консоль
  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;

  /// На вход получаем два параметра:
  /// 1) Если кнопка должна быть выделена
  /// 2) ValueSetter Нужен когда после нажания мы хотим иметь возможность виделеть но ничего в замен (возвращает нулевое значение)
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
    /// Создаем слушатель нажатий
    /// Чтобы он передавал в (bodyPartSetter) где мы находимя
    /// В Head или Torso
    /// Это передаеться в bodyPartSetter(head or torso)
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: ColoredBox(
          color:

          /// Тернарная конструкция
          /// Если selected тогда такой цвет else черный26
          selected ? const Color.fromRGBO(28, 121, 206, 1) : Colors.black26,
          child: Center(
            child: Text(bodyPart.name.toUpperCase()),
          ),
        ),
      ),
    );
  }
}
