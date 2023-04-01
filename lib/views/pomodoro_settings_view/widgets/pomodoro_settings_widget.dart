import 'package:flutter/material.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
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
    var l10n = L10n.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: ScreenPadding().screenPadding.copyWith(top: 20),
        child: Column(
          children: [
            ScreenTexts(
                title: l10n.pomodoroTitle,
                theme: Theme.of(context).textTheme.headlineMedium,
                fontW: FontWeight.w600,
                textPosition: TextAlign.left),
            ScreenTexts(
                title: l10n.pomodoroSubtitle,
                theme: Theme.of(context).textTheme.titleMedium,
                fontW: FontWeight.w400,
                textPosition: TextAlign.left),
            ScreenTexts(
                title: l10n.workTimer,
                theme: Theme.of(context).textTheme.titleMedium,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('20' '${l10n.minute}'),
                    Text('40' '${l10n.minute}')
                  ],
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
                title: l10n.breakTimer,
                theme: Theme.of(context).textTheme.titleMedium,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('5' '${l10n.minute}'),
                    Text('10' '${l10n.minute}')
                  ],
                ),
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
                title: l10n.longBreakTimer,
                theme: Theme.of(context).textTheme.titleMedium,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('15' '${l10n.minute}'),
                    Text('30' '${l10n.minute}')
                  ],
                ),
                Slider(
                  value: _longBreakTimeSliderValue.toDouble(),
                  max: 30,
                  min: 15,
                  divisions: 3,
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
                title: l10n.longBreakNumber,
                theme: Theme.of(context).textTheme.titleMedium,
                fontW: FontWeight.w500,
                textPosition: TextAlign.left),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.longBreak1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          l10n.longBreak5,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.end,
                        ),
                      )
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
                child: Text(l10n.updateButtonText))
          ],
        ),
      ),
    );
  }
}
