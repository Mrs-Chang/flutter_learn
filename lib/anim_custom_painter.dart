import 'dart:math';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;

  //定义100个Snowflake,x,y随机
  List<Snowflake> snowFlakes = List.generate(100, (index) => Snowflake());

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          //当_controller发生变化，AnimatedBuilder都会监听到并且重绘制
          child: Container(
        constraints: const BoxConstraints.expand(), //设置宽高match_parent
        // width: double.infinity,
        // height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.lightBlue, Colors.white],
          stops: [0.0, 0.7, 0.95],
        )),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            //雪花下落
            for (var snowflake in snowFlakes) {
              snowflake.fall(600);
            }
            return CustomPaint(
              painter: MyPainter(snowFlakes),
            );
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// 自定义 Painter
class MyPainter extends CustomPainter {
  final List<Snowflake> _snowflakes;
  final Paint  whitePaint = Paint()..color = Colors.white;
  MyPainter(this._snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    // print("1111 ${size}");
    //canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20.9, Paint());
    //canvas.drawCircle(size.center(const Offset(0, 0)), 20.9, Paint());
    //canvas.drawCircle(size.center(Offset.zero), 20.9, Paint());
    canvas.drawCircle(size.center(const Offset(0, 50)), 60.0, whitePaint);
    canvas.drawOval(
        Rect.fromCenter(
            center: size.center(const Offset(0, 210)), width: 200, height: 250),
        whitePaint);
    //雪花
    for (var snowflake in _snowflakes) {
      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.radius, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Snowflake {
  double x = Random().nextDouble() * 450;
  double y =  Random().nextDouble() * 40;
  double radius = Random().nextDouble() * 4 + 2;

  //下落速度
  double velocity = Random().nextDouble() * 4 + 2;

  //下落
  fall(double height) {
    y += velocity;
    if (y > height) {
      x = Random().nextDouble() * 450;
      y = 0;
      radius = Random().nextDouble() * 4 + 2;
      //下落速度
      velocity = Random().nextDouble() * 4 + 2;
    }
  }
}
