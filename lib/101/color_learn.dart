import 'package:flutter/material.dart';

class ColorLearn extends StatelessWidget {
  const ColorLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            color: ColorsItems.sulu,
            child: const Text('data')
          ),
        ],
      ),
    );
  }
}

class ColorsItems{
  static const Color porchase = Color(0xffEDBF61);

  static const Color sulu = Color.fromRGBO(198, 237, 97, 1);
}