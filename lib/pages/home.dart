import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/service/firebase_service.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/auth_widget_builder.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.userId});
  final userId;
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    AsyncSnapshot<PomotodoUser?> snapShot;
    return Scaffold(

      appBar: AppBar(
        title: Text(userId, style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.red)),
        actions: [IconButton(onPressed: ()async {await _authService.signOut();}, icon: const Icon(Icons.exit_to_app))],
      ),
    );
  }
}