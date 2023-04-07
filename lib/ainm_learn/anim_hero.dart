import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_learn/ainm_learn/details_screen.dart';

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

  @override
  void initState() {
    timeDilation = 3.0; //动画效果变慢
    //ticker使用
    Ticker ticker = Ticker((Duration duration) {
      print("Ticker $duration");
    });
    ticker.start();

    super.initState();
  }

  @override
  void dispose() {
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
      body: GridView.count(
        crossAxisCount: 5,
        children: List.generate(100, (index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            path:
                                "https://picsum.photos/200/300?random=$index")));
              },
              child: Hero(
                  tag: "https://picsum.photos/200/300?random=$index",
                  //根据关键字[tag]去匹配
                  child: Image(
                      image: NetworkImage(
                          "https://picsum.photos/200/300?random=$index"))));
        }),
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
