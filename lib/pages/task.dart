import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/add_task.dart';
import 'package:flutter_application_1/pages/edit_task.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/pages/pomodoro.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/database_service.dart';

class TaskView extends StatefulWidget with ProjectThemeOptions {
  TaskView({Key? key}) : super(key: key);

  @override
  State<TaskView> createState() => Task();
}

class Task extends State<TaskView> {
  DatabaseService service = DatabaseService();
  Future<List<TaskModel>>? taskList;
  List<TaskModel>? retrievedTaskList;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: ProjectThemeOptions().systemTheme,
          backgroundColor: ProjectThemeOptions().backGroundColor,
          actions: [
            AnimationSearchBar(
                previousScreen: PersonInfo(),
                searchFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                backIcon: Icons.tune,
                centerTitleStyle:
                    const TextStyle(color: Colors.white, fontSize: 18),
                backIconColor: Colors.white,
                searchIconColor: Colors.white,
                closeIconColor: Colors.white,
                centerTitle: 'PomoTodo',
                onChanged: (text) => debugPrint(text),
                searchTextEditingController: textController,
                horizontalPadding: 5)
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.black45,
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: Container(decoration: const BoxDecoration(border: Border(right: BorderSide(width: 0.5))),child: const Center(child: Text("0", style: TextStyle(fontSize: 20))))),
                    Expanded(child: Container(decoration: const BoxDecoration(border: Border(right: BorderSide(width: 0.5))),child: const Center(child: Text("0", style: TextStyle(fontSize: 20))))),
                    Expanded(child: Container(decoration: const BoxDecoration(border: Border(right: BorderSide(width: 0.5))),child: const Center(child: Text("0", style: TextStyle(fontSize: 20))))),
                    const Expanded(child: Center(child: Text("0", style: TextStyle(fontSize: 20)))),
                  ],
                ),
              )),
          Expanded(
            flex: 12,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: taskList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.separated(
                          itemCount: retrievedTaskList!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemBuilder: (context, index) {
                            return Dismissible(
                                onDismissed: ((direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    await service.deleteTask(
                                        retrievedTaskList![index]
                                            .id
                                            .toString());
                                    _refresh();
                                    _dismiss();
                                  } else {
                                    {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditTask(
                                                    isDone: retrievedTaskList![
                                                            index]
                                                        .isDone,
                                                    taskInfo:
                                                        retrievedTaskList![
                                                                index]
                                                            .taskInfo,
                                                    taskName:
                                                        retrievedTaskList![
                                                                index]
                                                            .taskName,
                                                    taskType:
                                                        retrievedTaskList![
                                                                index]
                                                            .taskType,
                                                    id: retrievedTaskList![
                                                            index]
                                                        .id
                                                        .toString(),
                                                  )),
                                          ModalRoute.withName("/EditTask"));
                                    }
                                  }
                                }),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Görev Silinecek!"),
                                          content: const Text(
                                              "Görevi silmek istediğinize emin misiniz?"),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text(
                                                "Onayla",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    ?.copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text(
                                                "İptal Et",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    ?.copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  return true;
                                },
                                background: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF21B7CA),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  padding: const EdgeInsets.only(left: 28.0),
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.edit, color: Colors.white),
                                      Text(
                                        "DÜZENLE",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                secondaryBackground: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    padding: const EdgeInsets.only(right: 28.0),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.delete, color: Colors.white),
                                        Text("SİL",
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    )),
                                resizeDuration:
                                    const Duration(milliseconds: 200),
                                key: UniqueKey(),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey[50],
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(15),
                                      leading: const Icon(Icons.numbers),
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PomodoroView(
                                                    task: retrievedTaskList![index],
                                                  )),
                                          ModalRoute.withName("/pomodoro"));
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      title: Text(
                                          retrievedTaskList![index].taskName),
                                      subtitle: Text(
                                          retrievedTaskList![index].taskInfo),
                                      trailing:
                                          const Icon(Icons.arrow_right_sharp),
                                    ),
                                  ),
                                ));
                          });
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        retrievedTaskList!.isEmpty) {
                      return Center(
                        child: ListView(
                          children: const <Widget>[
                            Align(
                                alignment: AlignmentDirectional.center,
                                child: Text('Görev bulunamadı!')),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.blue,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTask()),
          );
        },
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

  Future<void> _refresh() async {
    taskList = service.retrieveTasks();
    retrievedTaskList = await service.retrieveTasks();
    setState(() {});
  }

  void _dismiss() {
    taskList = service.retrieveTasks();
  }

  Future<void> _initRetrieval() async {
    taskList = service.retrieveTasks();
    retrievedTaskList = await service.retrieveTasks();
  }
}

class TaskAdded extends StatelessWidget {
  final title;
  final subtitle;
  final void Function()? onTouch;

  const TaskAdded(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.onTouch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            //shadowColor: Colors.red,
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blueGrey[50],
            child: Column(
              children: [
                ListTile(
                  //tileColor: Colors.red,
                  contentPadding: const EdgeInsets.all(15),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  //minVerticalPadding: 15,
                  //leading: const Icon(Icons.numbers),
                  title: title,
                  subtitle: Text(subtitle),
                  onTap: onTouch,
                )
              ],
            )));
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
