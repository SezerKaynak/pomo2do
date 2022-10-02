import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskView extends StatelessWidget with ProjectThemeOptions {
  TaskView({Key? key}) : super(key: key);
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: ProjectThemeOptions().systemTheme,
          backgroundColor: ProjectThemeOptions().backGroundColor,
          leading: TaskPageIconButton(
            taskIcons: Icons.person,
            onPressIconButton: () {
              ButtonsOnPressed().personInfoButton(context);
            },
          ),
          title: const Center(child: Text("PomoTodo")),
          actions: [
            AnimSearchBar(
              color: Colors.blue,
              width: 410,
              textController: textController,
              onSuffixTap: () {
                // setState(() {
                //   textController.clear();
                // });
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.black45,
            height: 60,
          ),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
          const TaskAdded(),
        ]),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.blue,
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TaskPageIconButton(
                taskIcons: Icons.home,
                onPressIconButton: () {
                  ButtonsOnPressed().homeButton;
                }),
            TaskPageIconButton(
                taskIcons: Icons.timer,
                onPressIconButton: () {
                  ButtonsOnPressed().timerButton;
                }),
            TaskPageIconButton(
                taskIcons: Icons.done,
                onPressIconButton: () {
                  ButtonsOnPressed().doneButton;
                }),
            TaskPageIconButton(
                taskIcons: Icons.stacked_bar_chart,
                onPressIconButton: () {
                  ButtonsOnPressed().stackedBarButton;
                }),
          ],
        ),
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
        icon: const Icon(Icons.add),
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
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(20),
            onPressed: doNothing,
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(20),
            onPressed: doNothing,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Sil',
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
                contentPadding: const EdgeInsets.all(15),
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
          )
        ),
      ),
    );
  }
}

class TaskPageIconButton extends StatelessWidget {
  const TaskPageIconButton({
    Key? key,
    required this.taskIcons,
    required this.onPressIconButton,
  }) : super(key: key);

  final IconData taskIcons;
  final void Function()? onPressIconButton;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      enableFeedback: false,
      onPressed: onPressIconButton,
      icon: Icon(
        taskIcons,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class ButtonsOnPressed {
  void personInfoButton(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PersonInfo()),
        ModalRoute.withName("/Task"));
  }

  void searchButton() {}
  void homeButton() {}
  void timerButton() {}
  void doneButton() {}
  void stackedBarButton() {}
}
