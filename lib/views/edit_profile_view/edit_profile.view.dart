import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/edit_profile_view/edit_profile.widgets.dart';

class EditProfileView extends StatelessWidget with EditProfileWidgets {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }
}
