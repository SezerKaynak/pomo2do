import 'package:flutter/material.dart';

class CardLearn extends StatelessWidget {
  const CardLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const NewCard(
              child: SizedBox(
                  height: 100, width: 500, child: Center(child: Text("Ali")))),
          const NewCard(
              child: SizedBox(
                  height: 100, width: 500, child: Center(child: Text("Ali")))),
          const NewCard(
              child: SizedBox(
                  height: 100, width: 400, child: Center(child: Text("Ata")))),
          Card(
            color: Theme.of(context).colorScheme.error,
            child: const SizedBox(height: 100, width: 100),
          )
        ],
      ),
    );
  }
}

class NewCard extends StatelessWidget {
  final Widget child;

  const NewCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: ProjectMargins.cardMargin,
      child: child,
    );
  }
}

class ProjectMargins {
  static const cardMargin = EdgeInsets.all(10);
}
