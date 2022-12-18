import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({
    Key? key,
    required this.tabName,
  }) : super(key: key);
  final String tabName;
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        size: Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: Center(child: Text(tabName)));
  }
}