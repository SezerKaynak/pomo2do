import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Deneme extends StatefulWidget {
  const Deneme({super.key});

  @override
  State<Deneme> createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _count;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _count = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('workTimerSelect') ?? 0;
    }
    );   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: _count,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ScreenTextField(textLabel: snapshot.data.toString(), obscure: false, controller: controller, height: 60, maxLines: 1);
                      }
                  }
            },
          ),
        ),
      ),
    );
  }
}