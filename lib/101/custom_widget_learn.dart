import 'package:flutter/material.dart';


class CustomWidgetLearn extends StatelessWidget {
  const CustomWidgetLearn({super.key});
  final String title = "Food";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: CustomFoodButton(title: title)),
            )),
        ],
      )
    );
  }
}


class _ColorsUtility{
  final Color redColor = Colors.red;
  final Color whiteColor = Colors.white;
}

class _PaddingUtility{
  final EdgeInsets normalPadding = const EdgeInsets.all(8.0);
  final EdgeInsets normal2xPadding = const EdgeInsets.all(16.0);
}

class CustomFoodButton extends StatelessWidget with _ColorsUtility, _PaddingUtility{
  CustomFoodButton({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: redColor, shape: const StadiumBorder()),
            onPressed: (){}, 
            child: Padding(
              padding: normal2xPadding,
              child: Text(title,
                style: Theme.of(context).textTheme.subtitle2?.copyWith(color: whiteColor, fontWeight: FontWeight.bold)
              ),
            )),
    );
  }
}