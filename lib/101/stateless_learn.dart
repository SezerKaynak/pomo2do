import 'package:flutter/material.dart';

class StatelessLearn extends StatelessWidget{
  const StatelessLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: const [
          TitleTextWidget(text: "veli1"),
          TitleTextWidget(text: "veli2"),
          TitleTextWidget(text: "veli3"),

          _CustomContainer(),
          SizedBox(height: 10)
          
        ],
      )
    );
  }

}

class _CustomContainer extends StatelessWidget {
  const _CustomContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.red),

      );
  }
}

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({super.key,required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline3,
    );
  }
}