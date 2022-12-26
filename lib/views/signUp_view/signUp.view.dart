import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/signUp_view/signUp.widgets.dart';

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
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[300])),
      ),
      body: body(context),
    );
  }
}
