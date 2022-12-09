import 'package:flutter/material.dart';
import 'package:flutter_application_1/project_theme_options.dart';

class AlertWidget extends StatelessWidget {
  AlertWidget({
    Key? key,
    required this.alertTitle,
    required this.alertSubtitle,
    this.alertApprove = "Onayla",
    this.alertReject = "İptal Et",
    this.isAlert = false
  }) : super(key: key);

  final String alertTitle;
  final String alertSubtitle;
  String alertApprove;
  String alertReject;
  bool isAlert;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(alertTitle),
      content: Text(alertSubtitle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            alertApprove,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: ProjectThemeOptions().backGroundColor),
          ),
        ),
        if(isAlert) TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            alertReject,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: ProjectThemeOptions().backGroundColor),
          ),
        ),
      ],
    );
  }
}