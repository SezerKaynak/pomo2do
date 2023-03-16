import 'package:flutter/material.dart';
import 'package:pomotodo/views/leaderboard_view/leaderboard.widgets.dart';

class LeaderboardView extends StatelessWidget with LeaderboardWidgets {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liderlik Sıralaması"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: body(context),
    );
  }
}
