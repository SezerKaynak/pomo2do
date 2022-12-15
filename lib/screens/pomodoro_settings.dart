import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroSettings extends StatelessWidget {
  const PomodoroSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var pomodoroTitle = "Pomodoro Ayarları";
    var pomodoroSubtitle =
        "Aşağıdaki alanlardan pomodoro zamanlayıcısının ayarlarını yapabilirsiniz.🙂";
    final TextEditingController workTimerController = TextEditingController();
    final TextEditingController breakTimerController = TextEditingController();
    final TextEditingController longBreakTimerController =
        TextEditingController();
    final TextEditingController longBreakNumberController =
        TextEditingController();
    var workTimer = "Çalışma Zamanı Süresi";
    var breakTimer = "Mola Süresi";
    var longBreakTimer = "Uzun Mola Süresi";
    var longBreakNumber = "Uzun Molanın Kaçıncı Arada Verileceği";
    var workTimerSelect = "Çalışma Zamanı Süresini Seçiniz";
    var breakTimerSelect = "Mola Süresini Seçiniz";
    var longBreakTimerSelect = "Uzun Mola Süresini Seçiniz";
    var longBreakNumberSelect =
        "Uzun Molanın Kaçıncı Arada Verileceğini Seçiniz";

    var workTimerList = [
      '20 dakika',
      '25 dakika',
      '30 dakika',
      '35 dakika',
      '40 dakika'
    ];
    var breakTimerList = [
      '5 dakika',
      '6 dakika',
      '7 dakika',
      '8 dakika',
      '9 dakika',
      '10 dakika'
    ];
    var longBreakTimerList = [
      '15 dakika',
      '16 dakika',
      '17 dakika',
      '18 dakika',
      '19 dakika',
      '20 dakika'
    ];
    var longBreakNumberList = ['1', '2', '3', '4', '5'];
    var list = [
      'workTimerSelect',
      'breakTimerSelect',
      'longBreakTimerSelect',
      'longBreakNumberSelect'
    ];

    Map<String, Object> values = <String, Object>{
      'workTimerSelect': 25,
      'breakTimerSelect': 5,
      'longBreakTimerSelect': 15,
      'longBreakNumberSelect': 1,
    };

    getSettings() async {
      final prefs = await SharedPreferences.getInstance();
      // if (prefs.getInt('workTimerSelect') == null) {
        // await prefs.setInt('workTimerSelect', 25);
        // await prefs.setInt('breakTimerSelect', 5);
        // await prefs.setInt('longBreakTimerSelect', 15);
        // await prefs.setInt('longBreakNumberSelect', 1);
      // }
      workTimerController.text = '${prefs.getInt('workTimerSelect')} dakika';
      breakTimerController.text = '${prefs.getInt('breakTimerSelect')} dakika';
      longBreakTimerController.text =
          '${prefs.getInt('longBreakTimerSelect')} dakika';
      longBreakNumberController.text =
          '${prefs.getInt('longBreakNumberSelect')}';

      // for (int i = 0; i < list.length; i++) {
      //   await prefs.remove(list[i]);
      // }
    }

    getSettings();

    return Scaffold(
      // backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[300])),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ScreenPadding().screenPadding.copyWith(top: 0),
          child: Column(
            children: [
              ScreenTexts(
                  title: pomodoroTitle,
                  theme: Theme.of(context).textTheme.headline4,
                  fontW: FontWeight.w600,
                  textPosition: TextAlign.left),
              ScreenTexts(
                  title: pomodoroSubtitle,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w400,
                  textPosition: TextAlign.left),
              ScreenTexts(
                  title: workTimer,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: workTimerSelect,
                  obscure: false,
                  controller: workTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      workTimerController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return workTimerList
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(value: value, child: Text(value));
                      }).toList();
                    },
                  ),
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: breakTimer,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: breakTimerSelect,
                  obscure: false,
                  controller: breakTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      breakTimerController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return breakTimerList
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(value: value, child: Text(value));
                      }).toList();
                    },
                  ),
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: longBreakTimer,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: longBreakTimerSelect,
                  obscure: false,
                  controller: longBreakTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      longBreakTimerController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return longBreakTimerList
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(value: value, child: Text(value));
                      }).toList();
                    },
                  ),
                  height: 70,
                  maxLines: 1),
              ScreenTexts(
                  title: longBreakNumber,
                  theme: Theme.of(context).textTheme.subtitle1,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left),
              ScreenTextField(
                  textLabel: longBreakNumberSelect,
                  obscure: false,
                  controller: longBreakNumberController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      longBreakNumberController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return longBreakNumberList
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(value: value, child: Text(value));
                      }).toList();
                    },
                  ),
                  height: 70,
                  maxLines: 1),
              Container(height: 30),
              const SizedBox(height: 40),
              SizedBox(
                  width: 400,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();

                        await prefs.setInt(
                            'workTimerSelect',
                            int.parse(
                                workTimerController.text.substring(0, 2)));
                        await prefs.setInt(
                            'breakTimerSelect',
                            int.parse(
                                breakTimerController.text.substring(0, 2)));
                        await prefs.setInt(
                            'longBreakTimerSelect',
                            int.parse(
                                longBreakTimerController.text.substring(0, 2)));
                        await prefs.setInt(
                            'longBreakNumberSelect',
                            int.parse(longBreakNumberController.text
                                .substring(0, 1)));

                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => TaskView()),
                          ModalRoute.withName('/'),
                        );
                      },
                      child: const Text("Güncelle"))),
            ],
          ),
        ),
      ),
    );
  }
}
