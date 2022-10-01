import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key, required this.snapShot});
  final AsyncSnapshot<PomotodoUser?> snapShot;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}