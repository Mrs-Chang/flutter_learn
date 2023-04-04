import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String path;
  const DetailScreen({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: path,//根据关键字[tag]去匹配
            child: Image(
              image: NetworkImage(path),
            )
          ),
        ),
      )
      );
  }

}