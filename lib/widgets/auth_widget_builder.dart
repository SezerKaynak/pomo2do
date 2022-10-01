import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:provider/provider.dart';
import '../models/pomotodo_user.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({super.key, required this.onPageBuilder});
  final Widget Function(BuildContext context, AsyncSnapshot<PomotodoUser?> snapShot) onPageBuilder;
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen:false);
    return StreamBuilder<PomotodoUser?>(
      stream: _authService.onAuthStateChanged,
      builder: (context,AsyncSnapshot<PomotodoUser?> snapShot) {
        final _userData = snapShot.data;
        if(_userData != null){
          return MultiProvider(
            providers: [
              Provider.value(value: _userData)
            ],
            child: onPageBuilder(context, snapShot));
        }
        return onPageBuilder(context, snapShot);
      }
    );
  }
}