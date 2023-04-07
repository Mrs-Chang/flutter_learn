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

  final boxes = [
    Box(const Color(0xFFBBDEFB), 0, key: UniqueKey()),
    Box(const Color(0xFF90CAF9), 1, key: UniqueKey()),
    Box(const Color(0xFF64B5F6), 2, key: UniqueKey()),
    Box(const Color(0xFF42A5F5), 3, key: UniqueKey()),
  ];

  _shuffle() {
    setState(() => boxes.shuffle());
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
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          if(newIndex > oldIndex) {
            newIndex -= 1;
          }
          final box = boxes.removeAt(oldIndex);
          boxes.insert(newIndex, box);
        },
        children: boxes,
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
  final Color? color;
  final int index;

  const Box(
    this.color,
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReorderableDragStartListener(
        index: index,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          width: 50,
          height: 50,
          color: color,
        ),
      ),
    );
  }
}
