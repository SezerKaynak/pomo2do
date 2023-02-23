import 'package:flutter/material.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/home_view/home.view.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/sign_in_view/widgets/sign_in_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroSettingsWidget extends StatefulWidget {
  const PomodoroSettingsWidget({super.key});

  @override
  State<PomodoroSettingsWidget> createState() => _PomodoroSettingsState();
}

class _PomodoroSettingsState extends State<PomodoroSettingsWidget> {
  late int _workTimeSliderValue;
  late int _breakTimeSliderValue;
  late int _longBreakTimeSliderValue;
  late int _setOfPomodoroSliderValue;

  @override
  void initState() {
    _workTimeSliderValue =
        context.read<SharedPreferences>().getInt('workTimerSelect')!;
    _breakTimeSliderValue =
        context.read<SharedPreferences>().getInt('breakTimerSelect')!;
    _longBreakTimeSliderValue =
        context.read<SharedPreferences>().getInt('longBreakTimerSelect')!;
    _setOfPomodoroSliderValue =
        context.read<SharedPreferences>().getInt('longBreakNumberSelect')!;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('20 dakika'), Text('40 dakika')],
                ),
                Slider(
                  value: _workTimeSliderValue.toDouble(),
                  min: 20,
                  max: 40,
                  divisions: 4,
                  label: '$_workTimeSliderValue $minute',
                  onChanged: (value) {
                    setState(() {
                      _workTimeSliderValue = value.toInt();
                    });
                  },
                ),
              ],
            ),
            ScreenTexts(
                title: breakTimer,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text("5 dakika"), Text("10 dakika")]),
                Slider(
                  value: _breakTimeSliderValue.toDouble(),
                  max: 10,
                  min: 5,
                  divisions: 5,
                  label: '$_breakTimeSliderValue $minute',
                  onChanged: (value) {
                    setState(() {
                      _breakTimeSliderValue = value.toInt();
                    });
                  },
                ),
              ],
            ),
            ScreenTexts(
                title: longBreakTimer,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text("15 dakika"), Text("20 dakika")]),
                Slider(
                  value: _longBreakTimeSliderValue.toDouble(),
                  max: 20,
                  min: 15,
                  divisions: 5,
                  label: '$_longBreakTimeSliderValue $minute',
                  onChanged: (value) {
                    setState(() {
                      _longBreakTimeSliderValue = value.toInt();
                    });
                  },
                ),
              ],
            ),
            ScreenTexts(
                title: longBreakNumber,
                theme: Theme.of(context).textTheme.subtitle1,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("1.arada uzun mola"),
                      Text("5.arada uzun mola")
                    ]),
                Slider(
                  value: _setOfPomodoroSliderValue.toDouble(),
                  max: 5,
                  min: 1,
                  divisions: 4,
                  label: '$_setOfPomodoroSliderValue',
                  onChanged: (value) {
                    setState(() {
                      _setOfPomodoroSliderValue = value.toInt();
                    });
                  },
                ),
              ],
            ),
            Container(height: 30),
            const SizedBox(height: 40),
            CustomElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setInt('workTimerSelect', _workTimeSliderValue);
                  await prefs.setInt('breakTimerSelect', _breakTimeSliderValue);
                  await prefs.setInt(
                      'longBreakTimerSelect', _longBreakTimeSliderValue);
                  await prefs.setInt(
                      'longBreakNumberSelect', _setOfPomodoroSliderValue);

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
