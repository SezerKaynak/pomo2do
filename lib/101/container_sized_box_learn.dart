import 'package:flutter/material.dart';

class ContainerSizedBoxLearn extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Text('a' * 500),

          ),
          const SizedBox.shrink(),
          SizedBox.square(
            dimension: 50,
            child: Text('b' * 50),
            ),
            Container(
              height: 50,
              color: Colors.red,
              constraints: const BoxConstraints(maxWidth: 150, minWidth: 50, maxHeight: 100),
              

              child: Text('aa' * 5),

            )
        ],
      ),
    );
  }
  
}