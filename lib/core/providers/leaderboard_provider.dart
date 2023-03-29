import 'package:flutter/material.dart';

class LeaderboardProvider extends ChangeNotifier {
  ValueNotifier<int> count = ValueNotifier<int>(0);
}
