import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:flutter_application_1/widgets/auth_widget_builder.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [IconButton(onPressed: ()async {await _authService.signOut();}, icon: const Icon(Icons.exit_to_app))],
      ),
    );
  }
}