import 'dart:math';

import 'package:flutter/material.dart';

class ColumnRowLearn extends StatelessWidget {
  const ColumnRowLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
            Expanded(flex: 4, child: Row(
              children: [
                Expanded(child: Container(color: Colors.red)),
                Expanded(child: Container(color: Colors.green)),
                Expanded(child: Container(color: Colors.blue)),
                Expanded(child: Container(color: Colors.pink)),
              ],
            )),
            const Spacer(flex:2),
            Expanded(flex: 2, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              ///mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ///mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("a"),
                Text("a2"),
                Text("a3"),
              ],
            )),
            const Expanded(flex: 2, child: FlutterLogo()),
      ],)
    );
  }
}