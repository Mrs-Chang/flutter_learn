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

  final _colors = [
    const Color(0xFFBBDEFB),
    const Color(0xFF90CAF9),
    const Color(0xFF64B5F6),
    const Color(0xFF42A5F5),
    Colors.blue,
    const Color(0xFF1E88E5),
  ];

  late int _slot;

  _shuffle() {
    setState(() => _colors.shuffle());
  }

  @override
  void initState() {
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
      body: Listener(
        onPointerMove: (event) {
          final x = event.position.dx;
          if (x > ((_slot + 1) * Box.width)) {
            if (_slot == _colors.length - 1) return;
            setState(() {
              final temp = _colors[_slot];
              _colors[_slot] = _colors[_slot + 1];
              _colors[_slot + 1] = temp;
              _slot++;
            });
          } else if (x < (_slot * Box.width)) {
            if (_slot == 0) return;
            setState(() {
              final temp = _colors[_slot];
              _colors[_slot] = _colors[_slot - 1];
              _colors[_slot - 1] = temp;
              _slot--;
            });
          }
        },
        child: Stack(
          children: List.generate(_colors.length, (i) {
            return Box(_colors[i], x: Box.width * i, y: Box.height,
                onDragStarted: (Color color) {
              final index = _colors.indexOf(color);
              _slot = index;
              print('onDragStarted: $index');
            }, key: ValueKey(_colors[i]));
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shuffle,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Box extends StatelessWidget {
  final Color color;
  final double x, y;
  static const double width = 60.0;
  static const double height = 60.0;
  static const double margin = 4.0;

  final Function(Color) onDragStarted;

  const Box(this.color,
      {Key? key, required this.x, required this.y, required this.onDragStarted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(

      top: y,
      left: x,
      duration: const Duration(milliseconds: 500),
      child: Draggable(
        onDragStarted: () => onDragStarted(color),
        childWhenDragging: Container(
          margin: const EdgeInsets.all(8.0),
          width: width - margin,
          height: height - margin,
        ),
        feedback: Container(
          margin: const EdgeInsets.all(8.0),
          width: width - margin,
          height: height - margin,
          color: color,
        ),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          width: width - margin,
          height: height - margin,
          color: color,
        ),
      ),
    );
  }
}
