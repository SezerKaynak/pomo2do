import 'package:flutter/material.dart';

class ScreenTextField extends StatelessWidget {
  const ScreenTextField({
    Key? key,
    required this.textLabel,
    required this.obscure,
    required this.controller,
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
  final int maxLines;
  final String? Function(String?)? valid;
  final Function()? onTouch;
  final Widget? con;
  final TextInputType? textFieldInputType;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textFieldInputType,
      onTap: onTouch,
      maxLines: maxLines,
      controller: controller,
      validator: valid,
      obscureText: obscure,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        //label: Align(alignment: Alignment.topLeft, child: Text(textLabel!)),
        labelStyle:
            MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
          final Color color = states.contains(MaterialState.error)
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).textTheme.bodySmall!.color!;
          return TextStyle(color: color);
        }),
        suffixIcon: suffix,
        icon: con,
        labelText: textLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
