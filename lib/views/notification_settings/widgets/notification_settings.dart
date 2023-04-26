import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/notification_settings/notification_settings.viewmodel.dart';
import 'package:provider/provider.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  List<Widget> alarmSettings = const [
    Icon(Icons.alarm_on),
    Icon(Icons.alarm_off),
  ];
  List<bool> selectedAlarmSetting = [true, false];
  late NotificationSettingsController notificationController;
  @override
  void initState() {
    notificationController =
        Provider.of<NotificationSettingsController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ScreenPadding.screenPadding.copyWith(top: 20),
      child: Column(
        children: [
          ScreenTexts(
            title: "Bildirim Ayarları",
            theme: Theme.of(context).textTheme.headlineMedium,
            fontW: FontWeight.w600,
            textPosition: TextAlign.left,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: ScreenTexts(
                  title: "Sayaç bitiminde alarm çalsın mı?",
                  theme: Theme.of(context).textTheme.titleMedium,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left,
                ),
              ),
              Consumer<NotificationSettingsController>(
                builder: (context, value, child) {
                  return CupertinoSwitch(
                    value: value.alarmSetting,
                    onChanged: (alarmValue) {
                      value.alarmSetting = alarmValue;
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: ScreenTexts(
                  title: "Sayaç bitiminde bildirim gönderilsin mi?",
                  theme: Theme.of(context).textTheme.titleMedium,
                  fontW: FontWeight.w500,
                  textPosition: TextAlign.left,
                ),
              ),
              Consumer<NotificationSettingsController>(
                builder: (context, value, child) {
                  return CupertinoSwitch(
                    value: value.notificationSetting,
                    onChanged: (notificationValue) {
                     value.notificationSetting = notificationValue;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
