import 'package:flutter/material.dart';
import 'package:pomotodo/l10n/app_l10n.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(child: Text(L10n.of(context)!.errorText))
    );
  }
}