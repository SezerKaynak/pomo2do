import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/views/common/widgets/screen_texts.dart';
import 'package:pomotodo/views/app_settings/app_settings.viewmodel.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({
    super.key,
    required this.settingTitle,
    required this.settingValue,
    required this.settingType,
  });

  final String settingTitle;
  final AppSettingsController settingValue;
  final String settingType;
  @override
  Widget build(BuildContext context) {
    switch (settingType) {
      case "Alarm":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            settingContent(context),
            CupertinoSwitch(
              activeColor: Theme.of(context).primaryColor,
              value: settingValue.alarmSetting,
              onChanged: (value) {
                settingValue.alarmSetting = value;
                settingValue.pauseSpotifySetting = true;
              },
            ),
          ],
        );
      case "Warning":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            settingContent(context),
            CupertinoSwitch(
              activeColor: Theme.of(context).primaryColor,
              value: settingValue.warnSetting,
              onChanged: (value) {
                settingValue.warnSetting = value;
              },
            ),
          ],
        );
      case "Spotify":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            settingContent(context),
            CupertinoSwitch(
              activeColor: Theme.of(context).primaryColor,
              value: settingValue.spotifySetting,
              onChanged: (value) {
                settingValue.spotifySetting = value;
              },
            ),
          ],
        );
      case "PauseSpotify":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            settingContent(context),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: context.read<AppSettingsController>().alarmSetting ||
                          !context.read<AppSettingsController>().spotifySetting
                      ? [Colors.grey, Colors.grey]
                      : [Colors.white, Colors.white],
                ).createShader(bounds);
              },
              child: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: settingValue.pauseSpotifySetting,
                onChanged: (value) {
                  context.read<AppSettingsController>().alarmSetting ||
                          !context.read<AppSettingsController>().spotifySetting
                      ? null
                      : settingValue.pauseSpotifySetting = value;
                },
              ),
            ),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            settingContent(context),
            CupertinoSwitch(
              activeColor: Theme.of(context).primaryColor,
              value: settingValue.notificationSetting,
              onChanged: (value) {
                settingValue.notificationSetting = value;
              },
            ),
          ],
        );
    }
  }

  SizedBox settingContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.4,
      child: ScreenTexts(
        title: settingTitle,
        theme: Theme.of(context).textTheme.bodyMedium,
        fontW: FontWeight.w400,
        textPosition: TextAlign.left,
      ),
    );
  }
}
