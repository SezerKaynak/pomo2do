import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/providers/tasks_provider.dart';
import 'package:pomotodo/core/service/i_auth_service.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({super.key, required this.onPageBuilder});
  final Widget Function(
          BuildContext context, AsyncSnapshot<PomotodoUser?> snapShot)
      onPageBuilder;
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return StreamBuilder<PomotodoUser?>(
        stream: _authService.onAuthStateChanged,
        builder: (context, AsyncSnapshot<PomotodoUser?> snapShot) {
          final _userData = snapShot.data;
          if (_userData != null) {
            return MultiProvider(providers: [
              Provider.value(value: _userData),
              ChangeNotifierProvider(create: (context) => TasksProvider()),
            ], child: onPageBuilder(context, snapShot));
          }
          return onPageBuilder(context, snapShot);
        });
  }
}
