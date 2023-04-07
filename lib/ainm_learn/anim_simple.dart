import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;

  // 默认的值是 0.0，也就是完全透明的
  late AnimationController _expansionController;
  late AnimationController _opacityController;

  @override
  void initState() {
    _expansionController = AnimationController(
      vsync: this,
      //duration: const Duration(seconds: 20), //这里动态改变
    );
    _opacityController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _expansionController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4 6 7 呼吸法
    Animation animation1 = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: const Interval(0.0, 0.2)))
        .animate(_expansionController);
    Animation animation2 = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: const Interval(0.2, 0.4)))
        .animate(_expansionController);
    Animation animation3 = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: const Interval(0.4, 0.95)))
        .animate(_expansionController);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.5).animate(_opacityController),
        child: AnimatedBuilder(
          animation: _expansionController,
          builder: (BuildContext context, Widget? child) {
            return Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                gradient: RadialGradient(
                  colors: const [Color(0xFF1E88E5), Color(0xFFBBDEFB)],
                  stops: [
                    _expansionController.value,
                    _expansionController.value + 0.1
                  ],
                ),
              ),
            );
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //4s
          _expansionController.duration = const Duration(seconds: 4);
          _expansionController.forward();
          await Future.delayed(const Duration(seconds: 4));
          //7s
          _opacityController.duration =
              const Duration(milliseconds: 1750); // 7000 / 4
          _opacityController.repeat(reverse: true);
          await Future.delayed(const Duration(seconds: 7));
          _opacityController.reset();
          //8s
          _expansionController.duration = const Duration(seconds: 8);
          _expansionController.reverse();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
