import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  Future.delayed(const Duration(seconds: 1), () => print("1")).then((value) {
    scheduleMicrotask(() {
      print("three");
    });
    print("one"); //说明 then 是被立即执行的
  }).then((value) => print("two"));
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

  Future<String> getFuture() {
    return Future(() => "alice");
  }

  //async 是语法糖，返回的是一个Future
  Future<String> getFutureAsync() async {
    return "alice";
  }

  Future<String> getFutureDelay() {
    //1秒后推到event queue里面，就是说最少要等1秒
    return Future.delayed(const Duration(seconds: 1), () => "alice delay");
  }

  void _incrementCounter() async{

    //await 相当与拆包 Future<String> -> String
    //async 相当于装包 String -> Future<String>
    String id = await getFutureAsync();

    http.get(Uri.parse('https://www.baidu.com')).then((value) {
      // print(value.statusCode);
    });
    getFuture().then((value) {
      print(value);
    });
    getFutureDelay().then((value) {
      print(value);
    });

    getFuture()
        .then((value) {
          print('value: $value');
          return "hello value"; //返回值会传递给下一个then
        })
        .then((value) {
          print('second value: $value');
           Future(() => print("hello future"));
        }).then((value) => print('null'))
        .catchError((onError) => print(onError))
        .whenComplete(() => print('complete'));

    getFuture()
        .then((value) {
      print('value: $value');
      return "hello value"; //返回值会传递给下一个then
    })
        .then((value) {
      print('second value: $value');
      return Future(() => print("hello future"));
    }).then((value) => print('null'))
        .catchError((onError) => print(onError))
        .whenComplete(() => print('complete'));

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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
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
