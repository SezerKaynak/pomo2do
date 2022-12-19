import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
    required this.settingIcon,
    required this.subtitle,
    required this.title,
    required this.tap,
  }) : super(key: key);

  final IconData settingIcon;
  final String subtitle;
  final Widget title;
  final Function() tap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              settingIcon,
              size: 40,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [title, const Icon(Icons.arrow_right_sharp)],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
