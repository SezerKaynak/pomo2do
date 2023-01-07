import 'package:flutter/material.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/home_view/home.view.dart';
import 'package:pomotodo/views/common/widgets/screen_text_field.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/sign_in_view/widgets/sign_in_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroSettingsWidget extends StatefulWidget {
  const PomodoroSettingsWidget({super.key});

  @override
  State<PomodoroSettingsWidget> createState() => _PomodoroSettingsState();
}

class _PomodoroSettingsState extends State<PomodoroSettingsWidget> {
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
      _breakTimerController.text =
          '${prefs.getInt('breakTimerSelect')} $minute';
      _longBreakTimerController.text =
          '${prefs.getInt('longBreakTimerSelect')} $minute';
      _longBreakNumberController.text =
          '${prefs.getInt('longBreakNumberSelect')}';

      // for (int i = 0; i < list.length; i++) {
      //   await prefs.remove(list[i]);
      // }
    }

    getSettings();

    return SingleChildScrollView(
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
                maxLines: 1),
            ScreenTexts(
                title: breakTimer,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: breakTimerSelect,
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
                maxLines: 1),
            ScreenTexts(
                title: longBreakTimer,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: longBreakTimerSelect,
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
                maxLines: 1),
            ScreenTexts(
                title: longBreakNumber,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            ScreenTextField(
                textLabel: longBreakNumberSelect,
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
                maxLines: 1),
            Container(height: 30),
            const SizedBox(height: 40),
            CustomElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setInt('workTimerSelect',
                      int.parse(_workTimerController.text.substring(0, 2)));
                  await prefs.setInt('breakTimerSelect',
                      int.parse(_breakTimerController.text.substring(0, 2)));
                  await prefs.setInt(
                      'longBreakTimerSelect',
                      int.parse(
                          _longBreakTimerController.text.substring(0, 2)));
                  await prefs.setInt(
                      'longBreakNumberSelect',
                      int.parse(
                          _longBreakNumberController.text.substring(0, 1)));

                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const HomeView()),
                    ModalRoute.withName('/'),
                  );
                },
                child: const Text(updateButtonText))
          ],
        ),
      ),
    );
  }
}
