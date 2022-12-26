import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/sign_in_view/sign_in.widgets.dart';

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
