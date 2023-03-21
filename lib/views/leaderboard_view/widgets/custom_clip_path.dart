import 'package:flutter/material.dart';

class CustomClipPath extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Color color;
  final double height;
  final String? text;
  final double fontSize;

  const CustomClipPath({
    super.key,
    required this.clipper,
    required this.color,
    required this.height,
    this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: clipper,
      child: Container(
        color: color,
        height: height,
        width: MediaQuery.of(context).size.width / 4,
        child: Center(
          child: Text(
            text ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
