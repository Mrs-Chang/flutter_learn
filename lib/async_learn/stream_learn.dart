import 'dart:async';
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final future = Future<int>.delayed(const Duration(seconds: 1), () => 42);
  final stream = Stream<int>.periodic(const Duration(seconds: 1), (x) => 43);

  final controller = StreamController<int>();//默认只能有一个监听者
  final controller1 = StreamController<int>.broadcast();//处理上面的问题，但是广播的形式数据不会被保留

  //语法糖
  Stream<int> getInt() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield 42;
  }


  void _incrementCounter() {
    //future.then((value) => print('value $value'));
    //stream.listen((event) => print('event $event'));
    controller.sink.add(Random().nextInt(100));
    if (_counter == 4) {
      controller.close();
    }
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    //controller.sink.add(1); // sink 源头
    //controller.stream.listen((event) => print('event $event')); // stream 消费者

    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline4!,
        child: Center(
          child: StreamBuilder(
            stream: controller.stream, // stream 发生变化时，StreamBuilder 会重新构建
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none: //stream为空
                  return const Text('none');
                case ConnectionState.waiting: //等待数据
                  return const Text('waiting');
                case ConnectionState.active:
                  if (snapshot.hasError) {
                    return Text('error ${snapshot.error}');
                  }
                  return Text('active ${snapshot.data}');
                case ConnectionState.done: //stream关闭
                  return const Text('done');
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
