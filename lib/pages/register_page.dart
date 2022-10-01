import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: const Text("Kayıt ol"),
    );
  }
}