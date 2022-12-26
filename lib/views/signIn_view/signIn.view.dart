import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/signIn_view/signIn.widgets.dart';

class SignInView extends StatelessWidget with SignInWidgets {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: body(context),
    );
  }
}
