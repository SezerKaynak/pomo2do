import 'package:flutter/material.dart';
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
          onPressed: () {}, label: const Text("Ekle")),
    );
  }
}

class TaskAdded extends StatelessWidget {
  const TaskAdded({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var doNothing;
    return Slidable(
      child: Center(
        child: Card(
            child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.numbers),
              title: const Text("Görev ismi"),
              subtitle: const Text("Görev açıklaması"),
              onTap: () {},
            )
          ],
        )),
      ),
      startActionPane: ActionPane(
    // A motion is a widget used to control how the pane animates.
    motion: const ScrollMotion(),

    // A pane can dismiss the Slidable.
    dismissible: DismissiblePane(onDismissed: () {}),

    // All actions are defined in the children parameter.
    children: [
      // A SlidableAction can have an icon and/or a label.
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
  //     actions: <Widget>[
  //   new IconSlideAction(
  //     caption: 'Archive',
  //     color: Colors.blue,
  //     icon: Icons.archive,
  //     onTap: () => _showSnackBar('Archive'),
  //   ),
  //   new IconSlideAction(
  //     caption: 'Share',
  //     color: Colors.indigo,
  //     icon: Icons.share,
  //     onTap: () => _showSnackBar('Share'),
  //   ),
  // ],
  // secondaryActions: <Widget>[
  //   new IconSlideAction(
  //     caption: 'More',
  //     color: Colors.black45,
  //     icon: Icons.more_horiz,
  //     onTap: () => _showSnackBar('More'),
  //   ),
  //   new IconSlideAction(
  //     caption: 'Delete',
  //     color: Colors.red,
  //     icon: Icons.delete,
  //     onTap: () => _showSnackBar('Delete'),
  //   ),
  // ],
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
