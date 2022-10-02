import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskView extends StatelessWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          //title:Text("PomoTodo",),
          title: const Center(
              child: Text(
            "PomoTodo",
          )),
          leading: TaskPageIconButton(taskIcons: Icons.search),
          actions: [
            TaskPageIconButton(taskIcons: Icons.person),
          ]),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TaskPageIconButton(taskIcons: Icons.home),
            TaskPageIconButton(taskIcons: Icons.timer),
            TaskPageIconButton(taskIcons: Icons.done),
            TaskPageIconButton(taskIcons: Icons.stacked_bar_chart),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.black45,
            height: 60,
          ),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded(),
          TaskAdded()
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          "Ekle",
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.white),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class TaskAdded extends StatelessWidget {
  const TaskAdded({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var doNothing;
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      child: Center(
        child: Card(
            shadowColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blueGrey[50],
            child: Column(
              children: [
                ListTile(
                  //tileColor: Colors.red,
                  contentPadding: EdgeInsets.all(15),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  //minVerticalPadding: 15,
                  leading: const Icon(Icons.numbers),
                  title: ScreenTexts(
                      title: "Görev İsmi",
                      theme: Theme.of(context).textTheme.subtitle1,
                      fontW: FontWeight.w400,
                      textPosition: TextAlign.left),
                  subtitle: const Text("Görev açıklaması"),
                  onTap: () {},
                )
              ],
            )),
      ),
    );
  }
}

class TaskPageIconButton extends StatelessWidget {
  TaskPageIconButton({
    Key? key,
    required this.taskIcons,
  }) : super(key: key);

  final IconData taskIcons;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      enableFeedback: false,
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Ogrencibilgi()),
        // );
      },
      icon: Icon(
        taskIcons,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
