import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarLearnView extends StatelessWidget {
  const AppBarLearnView({super.key});
  final String _title = 'Welcome Learn';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actionsIconTheme: const IconThemeData(color: Colors.red, size:50),

        leading: const Icon(Icons.chevron_left),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.mark_email_unread_sharp)),
          ],
          
      ),
      body: Column(children: const[]),
    );
  }
}