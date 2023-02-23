import 'package:flutter/material.dart';
import 'package:pomotodo/views/sign_up_view/sign_up.widgets.dart';

class SignUpView extends StatelessWidget with SignUpWidgets {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: body(context),
    );
  }
}
