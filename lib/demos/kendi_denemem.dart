import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KendiDenemem extends StatelessWidget {
  const KendiDenemem({super.key});

  @override
  Widget build(BuildContext context) {
    var createNote = "Create your first note";
    var addNote = "Add a note about anything (your thoughts on climate change, or your history essay and share it witht the world.";
    var noteImport = "Import Notes";
    var createNoteButton = "Create a new note";
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: ProjectPaddings().horizontalPadding,
        child: Column(children: [
          Image.asset("assets/png/apple.png"),
          Text(
            createNote, 
            style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w700)
          ),
          Text(
            addNote,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w400, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _CreateNoteButton(buttonName: createNoteButton),
          TextButton(onPressed: (){}, child: Text(noteImport)),
          const SizedBox(height: 50)
        ],),
      )
    );
  }
}

class _CreateNoteButton extends StatelessWidget {
  const _CreateNoteButton({
    Key? key, required this.buttonName,
  }) : super(key: key);
  final String buttonName;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){}, 
      child: SizedBox(
        height: 50,
        width: 400,
        child: Center(
          child: Text(
            buttonName,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ));
  }
}

class ProjectPaddings{
  final EdgeInsets horizontalPadding = const EdgeInsets.symmetric(horizontal: 20);
  final EdgeInsets verticalPadding = const EdgeInsets.symmetric(vertical: 10);
}