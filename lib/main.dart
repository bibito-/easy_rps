import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const JankenPage(),
    );
  }
}

class JankenPage extends StatefulWidget {
  const JankenPage({super.key});

  @override
  State<JankenPage> createState() => _JankenPageState();
}

// コンピューター側
Junken computerHand = Junken.rock;
// プレイヤーの手
Junken myHand = Junken.rock;

var judge = 'あなたが出す手をタップしてください';

// リファクタリングするならプレイヤーとコンピュータの手を保持するインスタンスを作って
// 論理部を抽出する　現状メインクラスに状態をベタがき
// MVVCに則るなら、ウィジェットの状態を意識して書き分ける

// var player = Hand();
// var computer = Hand();

// class Hand {
//   final int _wins = 0;
//   final Junken _card = Junken.rock;
// }

enum Junken {
  rock('👊'),
  scissors('✌️'),
  paper('🖐️');

  final String _emoji;
  const Junken(this._emoji);
}

extension JunkenExtension on Junken {
  String get name => toString().split('.').last;
  String get emoji => _emoji;
}

class _JankenPageState extends State<JankenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Janken'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 勝利判定
            Text(
              judge,
              style: const TextStyle(fontSize: 20),
            ),
            // コンピューターの手
            Text(
              computerHand.emoji,
              style: const TextStyle(fontSize: 45),
            ),
            const SizedBox(
              height: 16,
            ),
            // 選択した自分の手を表示
            Text(
              myHand.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // じゃんけんのウィジェットと論理部分をセット
              children: [
                createJunkenWidget(Junken.rock),
                createJunkenWidget(Junken.scissors),
                createJunkenWidget(Junken.paper),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton createJunkenWidget(Junken card) => ElevatedButton(
      onPressed: () {
        // 論理部
        myHand = card;
        computerHand = generateComputerHand();
        calculate();
        setState(() {});
      },
      child: Text(card.emoji));

  Junken generateComputerHand() {
    final randomNum = Random().nextInt(Junken.values.length);
    final nextHand = Junken.values[randomNum];
    debugPrint('computer Hand: $nextHand');
    return nextHand;
  }

  void calculate() {
    List<Junken> cards = Junken.values;
    final int handHeight = cards.indexOf(myHand);
    final int result = (handHeight - cards.indexOf(computerHand)) % 3;
    if (result == 0) {
      judge = '引き分け';
    } else if (result == 2) {
      judge = '勝ち';
    } else {
      judge = '負け';
    }
  }
}
