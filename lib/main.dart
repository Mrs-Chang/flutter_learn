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

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SlidingBox(
                  controller: _controller,
                  color: Colors.blue,
                  interval: const Interval(0.0, 0.2)),
              SlidingBox(
                  controller: _controller,
                  color: Colors.blue,
                  interval: const Interval(0.2, 0.4)),
              SlidingBox(
                  controller: _controller,
                  color: Colors.blue,
                  interval: const Interval(0.4, 0.6)),
              SlidingBox(
                  controller: _controller,
                  color: Colors.blue,
                  interval: const Interval(0.6, 0.8)),
              SlidingBox(
                  controller: _controller,
                  color: Colors.blue,
                  interval: const Interval(0.8, 1.0)),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//封装为一个组件
class SlidingBox extends StatelessWidget {
  const SlidingBox({
    Key? key,
    required AnimationController controller,
    required Color color,
    required Interval interval,
  })  : _controller = controller,
        _color = color,
        _interval = interval,
        super(key: key);
  final AnimationController _controller;
  final Color _color;
  final Interval _interval;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0.15, 0),
        ).chain(CurveTween(curve: _interval)).animate(_controller),
        child: Container(width: 300, height: 100, color: _color));
  }
}
