import 'package:flutter/material.dart';


class StackDemoView extends StatelessWidget {
  const StackDemoView({super.key});

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 50;
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Expanded(flex: 4, child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(bottom: 10,child: Image.asset("assets/png/apple.png")),
            const Positioned(
              height: cardHeight,
              bottom: 0,
              width: 200,
              child: Card(
                color: Colors.red,
                shape: RoundedRectangleBorder(),
              ))
          ],
        )),
        const Spacer(flex: 6)
    
        
        ]
      ),
    );
  }
}