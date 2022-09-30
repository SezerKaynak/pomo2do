import 'package:flutter/material.dart';

class PaddingLearn extends StatelessWidget {
  const PaddingLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: ProjectPadding.pagePaddingVertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(color: Colors.white, height: 100),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Container(color: Colors.white, height: 100),
              ),
              Padding(
                padding: ProjectPadding.pagePaddingRight +
                    ProjectPadding.pagePaddingVertical,
                child: const Text("Ali"),
              )
            ],
          ),
        ));
  }
}

class ProjectPadding {
  static const pagePaddingVertical = EdgeInsets.symmetric(vertical: 10);

  static const pagePaddingRight = EdgeInsets.only(right: 10);
}
