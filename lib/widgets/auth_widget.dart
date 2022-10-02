import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:flutter_application_1/widgets/error_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key, required this.snapShot});
  final AsyncSnapshot<PomotodoUser?> snapShot; 
  @override
  Widget build(BuildContext context) {
    if(snapShot.connectionState == ConnectionState.active){
      return snapShot.hasData ? HomeScreen(userId: snapShot.data!.userId): const LoginPage();
    }
    return const ErrorPage();
  }
}

