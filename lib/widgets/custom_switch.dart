import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch(
      {super.key, required this.switchValue, required this.switchOnChanged});
  final bool switchValue;
  final Function(bool) switchOnChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.light_mode, color: Colors.amber),
        Switch(
          value: switchValue,
          activeColor: Colors.black87,
          onChanged: switchOnChanged,
        ),
        const Icon(Icons.dark_mode)
      ],
    );
  }
}
