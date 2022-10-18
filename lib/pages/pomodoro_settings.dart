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
    var workTimer = "Çalışma Zamanı Süresi";
    var breakTimer = "Mola Süresi";
    var longBreakTimer = "Uzun Mola Süresi";
    var longBreakNumber = "Uzun Molanın Kaçıncı Arada Verileceği";

    var items = [
      'Working a lot harder',
      'Being a lot smarter',
      'Being a self-starter',
      'Placed in charge of trading charter'
    ];

    final TextEditingController _workTimerController = TextEditingController();
    final TextEditingController _breakTimerController = TextEditingController();
    final TextEditingController _longBreakTimerController =
        TextEditingController();
    final TextEditingController _longBreakNumberController =
        TextEditingController();

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
                  textLabel: workTimer,
                  obscure: false,
                  controller: _workTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _workTimerController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return items.map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
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
                  textLabel: breakTimer,
                  obscure: false,
                  controller: _breakTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _breakTimerController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return items.map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
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
                  textLabel: longBreakTimer,
                  obscure: false,
                  controller: _longBreakTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _longBreakTimerController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return items.map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
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
                  textLabel: longBreakNumber,
                  obscure: false,
                  controller: _longBreakNumberController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _longBreakNumberController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return items.map<PopupMenuItem<String>>((String value) {
                        return new PopupMenuItem(
                            child: new Text(value), value: value);
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => TaskView()),
                            ModalRoute.withName("/Person"));
                      },
                      child: const Text("Güncelle"))),
            ],
          ),
        ),
      ),
    );
  }
}
