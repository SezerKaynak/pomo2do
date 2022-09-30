import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proje/101/image_learn.dart';

class NoteDemos extends StatelessWidget {
  const NoteDemos({super.key});

  @override
  Widget build(BuildContext context) {
    var title = "Create your first note";
    var description = "Add a note about anything (your thoughts on climate change, or your history essay amd share it witht the world.";
    var createNote = "Create a new note";
    var noteImport = "Import Notes";
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark
      ),
      body: Padding(
        padding: PaddingItems.horizontalPadding,
        child: Column(
          children: [
            const PngImage(name: "apple"), 
            _TitleWidget(title: title),
            Padding(
              padding: PaddingItems.verticalPadding,
              child: _SubtitleWidget(subtitle: description, textAlign: TextAlign.center),
            ),
            const Spacer(),
            _createButton(createNote, context),
            TextButton(onPressed: (){}, child: Text(noteImport)),
            const SizedBox(height: ButtonHeights.buttonNormalHeight)
          ],     
        ),
      ),
    );
  }

  ElevatedButton _createButton(String createNote, BuildContext context) {
    return ElevatedButton(
            onPressed: (){}, 
            child: SizedBox(
              height: ButtonHeights.buttonNormalHeight,
              child: Center(child: Text(createNote,
                style: Theme.of(context).textTheme.headline6,
              ))));
  }
}

/// Center text widget
class _SubtitleWidget extends StatelessWidget {
  const _SubtitleWidget({
    Key? key, this.textAlign = TextAlign.center, required this.subtitle,
  }) : super(key: key);

  final TextAlign textAlign;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle, 
      textAlign: textAlign,
      style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18));
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black, fontWeight: FontWeight.w700)
      );
  }
}

class PaddingItems {
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: 10);
}

class ButtonHeights{
  static const double buttonNormalHeight = 50;
}