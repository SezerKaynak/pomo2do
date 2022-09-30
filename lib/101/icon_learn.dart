import 'package:flutter/material.dart';

class IconLearnView extends StatelessWidget {
  IconLearnView({super.key});
  final iconSize = IconSizes();
  final iconColor = IconColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
      body: Column(children: [
        IconButton(onPressed: (){}, 
        icon: Icon(
          Icons.message_outlined,
          color: iconColor.froly,
          size: iconSize.iconSmall,
        
        )),

        IconButton(
          onPressed: (){}, 
          icon: const Icon(
            Icons.message_outlined,
            color: Colors.red,
            size: 30,
            ))
      ]),
    );
  }
}

class IconSizes{
  final double iconSmall = 40;
}

class IconColors{
  final Color froly = const Color(0xffED617A);
}