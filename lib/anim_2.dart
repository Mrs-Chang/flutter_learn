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

  // 默认的值是 0.0，也就是完全透明的
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
    final Animation opacityAnimation =
        Tween<double>(begin: 0.5, end: 0.8)
            .chain(CurveTween(curve: Curves.bounceInOut))
            .animate(_controller);
    final Animation heightAnimation =
        Tween<double>(begin: 100, end: 300).animate(_controller);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          //当_controller发生变化，AnimatedBuilder都会监听到并且重绘制
          child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          //child优化，避免重复创建
          return Opacity(
            opacity: opacityAnimation.value,
            child: Container(
              width: 300,
              height: Tween<double>(begin: 100, end: 300).evaluate(_controller),//<===这里可以替换为heightAnimation.value
              color: Colors.blue,
              child: child, //<===下面传的child是不会根据动画变化的，所以我们传递给这里
            ),
          );
        },
        child: const Center(
          child: Text(
            'Hello',
            style: TextStyle(fontSize: 70),
          ),
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
