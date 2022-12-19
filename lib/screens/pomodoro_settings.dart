import 'package:flutter/material.dart';
import 'package:flutter_application_1/assets/constants.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:flutter_application_1/widgets/screen_texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroSettings extends StatefulWidget {
  const PomodoroSettings({super.key});

  @override
  State<PomodoroSettings> createState() => _PomodoroSettingsState();
}

class _PomodoroSettingsState extends State<PomodoroSettings> {
  late TextEditingController _workTimerController;
  late TextEditingController _breakTimerController;
  late TextEditingController _longBreakTimerController;
  late TextEditingController _longBreakNumberController;

  @override
  void initState() {
    _workTimerController = TextEditingController();
    _breakTimerController = TextEditingController();
    _longBreakTimerController = TextEditingController();
    _longBreakNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _workTimerController.dispose();
    _breakTimerController.dispose();
    _longBreakTimerController.dispose();
    _longBreakNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getSettings() async {
      final prefs = await SharedPreferences.getInstance();

      _workTimerController.text = '${prefs.getInt('workTimerSelect')} $minute';
      _breakTimerController.text = '${prefs.getInt('breakTimerSelect')} $minute';
      _longBreakTimerController.text =
          '${prefs.getInt('longBreakTimerSelect')} $minute';
      _longBreakNumberController.text =
          '${prefs.getInt('longBreakNumberSelect')}';

      // for (int i = 0; i < list.length; i++) {
      //   await prefs.remove(list[i]);
      // }
    }

    getSettings();

    return Scaffold(
      appBar: AppBar(
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
                  controller: _workTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _workTimerController.text = value;
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
                  controller: _breakTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _breakTimerController.text = value;
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
                  controller: _longBreakTimerController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _longBreakTimerController.text = value;
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
                  controller: _longBreakNumberController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _longBreakNumberController.text = value;
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
                                _workTimerController.text.substring(0, 2)));
                        await prefs.setInt(
                            'breakTimerSelect',
                            int.parse(
                                _breakTimerController.text.substring(0, 2)));
                        await prefs.setInt(
                            'longBreakTimerSelect',
                            int.parse(_longBreakTimerController.text
                                .substring(0, 2)));
                        await prefs.setInt(
                            'longBreakNumberSelect',
                            int.parse(_longBreakNumberController.text
                                .substring(0, 1)));

                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => TaskView()),
                          ModalRoute.withName('/'),
                        );
                      },
                      child: const Text(updateButtonText))),
            ],
          ),
        ),
      ),
    );
  }
}
