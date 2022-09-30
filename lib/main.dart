import 'package:flutter/material.dart';
import 'package:flutter_proje/101/app_bar_learn.dart';
import 'package:flutter_proje/101/button_learn.dart';
import 'package:flutter_proje/101/card_learn.dart';
import 'package:flutter_proje/101/color_learn.dart';
import 'package:flutter_proje/101/column_row_learn.dart';
import 'package:flutter_proje/101/container_sized_box_learn.dart';
import 'package:flutter_proje/101/custom_widget_learn.dart';
import 'package:flutter_proje/101/icon_learn.dart';
import 'package:flutter_proje/101/image_learn.dart';
import 'package:flutter_proje/101/indicator_learn.dart';
import 'package:flutter_proje/101/list_tile_learn.dart';
import 'package:flutter_proje/101/padding_learn.dart';
import 'package:flutter_proje/101/scaffold_learn.dart';
import 'package:flutter_proje/101/stack_learn.dart';
import 'package:flutter_proje/101/stateless_learn.dart';
import 'package:flutter_proje/101/text_learn_view.dart';
import 'package:flutter_proje/demos/kendi_denemem.dart';
import 'package:flutter_proje/demos/note_demos_view.dart';
import 'package:flutter_proje/demos/stack_demo_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      theme: ThemeData.dark().copyWith(
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.white,
          ),
          cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Color(0xff4C87B7),
            elevation: 0,
          )),
      home: const CustomWidgetLearn(),
    );
  }
}
