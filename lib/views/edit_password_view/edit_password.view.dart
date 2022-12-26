import 'package:flutter/material.dart';
import 'package:pomotodo/views/edit_password_view/edit_password.widgets.dart';

class EditPasswordView extends StatelessWidget with EditPasswordWidgets {
  const EditPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
        actions: [
          if (isLoading)
            // ignore: dead_code
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child:
                      CircularProgressIndicator(color: Colors.blueGrey[300])),
            )
        ],
      ),
      body: body(context),
    );
  }
}
