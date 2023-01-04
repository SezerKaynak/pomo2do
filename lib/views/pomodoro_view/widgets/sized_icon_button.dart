import 'package:flutter/material.dart';

class SizedIconButton extends StatelessWidget {
  const SizedIconButton({
    Key? key,
    required this.width,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final double width;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.black,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: Colors.white)),
        ),
      ),
    );
  }
}
