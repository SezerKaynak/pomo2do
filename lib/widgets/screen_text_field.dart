import 'package:flutter/material.dart';

class ScreenTextField extends StatelessWidget {
  const ScreenTextField({
    Key? key,
    required this.textLabel,
    required this.obscure,
    required this.controller,
    required this.height,
    required this.maxLines,
    this.valid,
    this.onTouch,
    this.con,
    this.textFieldInputType = TextInputType.text,
    this.suffix,
  }) : super(key: key);
  final String? textLabel;
  final bool obscure;
  final TextEditingController controller;
  final double height;
  final int maxLines;
  final String? Function(String?)? valid;
  final Function()? onTouch;
  final Widget? con;
  final TextInputType? textFieldInputType;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: TextFormField(
          keyboardType: textFieldInputType,
          onTap: onTouch,
          maxLines: maxLines,
          controller: controller,
          validator: valid,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: suffix,
            icon: con,
            labelText: textLabel,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}