import 'package:flutter/material.dart';

class ScreenTexts extends StatelessWidget {
  const ScreenTexts({
    Key? key,
    this.customPadding,
    required this.title,
    required this.theme,
    required this.fontW,
    required this.textPosition,
  }) : super(key: key);
  final String title;
  final TextStyle? theme;
  final FontWeight fontW;
  final TextAlign textPosition;
  final EdgeInsetsGeometry? customPadding;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        child: Padding(
          padding: customPadding ?? const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(title,
              textAlign: textPosition,
              style: theme?.copyWith(fontWeight: fontW, color: Colors.black)),
        ));
  }
}