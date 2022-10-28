import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/task.dart';

class PomodoroSettings extends StatefulWidget {
  const PomodoroSettings({super.key});

  @override
  State<PomodoroSettings> createState() => _PomodoroSettingsState();
}

class _PomodoroSettingsState extends State<PomodoroSettings> {
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

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
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
                        print(workTimerSelect);
                        setState(() {
                          workTimerSelect = workTimerController.text;
                        });
                        print(workTimerSelect);

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
