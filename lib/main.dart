import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: "La Dheel A.i"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tiles = List.filled(9, 0);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 0.4,
            child: GridView.count(
              mainAxisSpacing: (itemWidth / itemHeight),
              crossAxisCount: 3,
              shrinkWrap: true,
              controller: ScrollController(keepScrollOffset: false),
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < 9; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        tiles[i] = 1;
                        runAi();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Text(tiles[i] == 0
                                ? ''
                                : tiles[i] == 1
                                    ? 'X'
                                    : 'O')),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(isWinning(1, tiles)
                  ? 'You won!'
                  : isWinning(2, tiles)
                      ? 'You lost!'
                      : 'Your move'),
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      tiles = List.filled(9, 0);
                    });
                  },
                  child: const Text('Restart'))
            ],
          ),
        ],
      ),
    );
  }

  void runAi() async {
    await Future.delayed(const Duration(milliseconds: 200));

    int? winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++) {
      var val = tiles[i];

      if (val > 0) {
        continue;
      }

      var future = [...tiles]..[i] = 2;

      if (isWinning(2, future)) {
        winning = i;
      }

      future[i] = 1;

      if (isWinning(1, future)) {
        blocking = i;
      }

      normal = i;
    }

    var move = winning ?? blocking ?? normal;

    if (move != null) {
      setState(() {
        tiles[move] = 2;
      });
    }
  }

  bool isWinning(int who, List<int> tiles) {
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who) ||
        (tiles[2] == who && tiles[4] == who && tiles[6] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who);
  }
}
