import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/add_task.dart';
import 'package:flutter_application_1/pages/edit_task.dart';
import 'package:flutter_application_1/pages/pomodoro.dart';
import 'package:flutter_application_1/pages/search_view.dart';
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
  List<TaskModel>? tasks;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  String alertTitle = "Görev Silinecek!";
  String alertSubtitle = "Görevi silmek istediğinize emin misiniz?";
  String alertApprove = "Onayla";
  String alertReject = "İptal Et";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: ProjectThemeOptions().systemTheme,
          backgroundColor: ProjectThemeOptions().backGroundColor,
          title: const Text("PomoTodo",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                ButtonsOnPressed().personInfoButton(context);
              },
              icon: const Icon(Icons.tune)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchView()));
                },
                icon: const Icon(Icons.search))
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.black45,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                                border: Border(right: BorderSide(width: 0.5))),
                            child: FutureBuilder(
                                future: taskList,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<TaskModel>> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    return Center(
                                        child: Text(
                                      retrievedTaskList?.length.toString() ??
                                          "0",
                                      style: const TextStyle(fontSize: 20),
                                    ));
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      retrievedTaskList!.isEmpty) {
                                    return const Center(
                                        child: Text("0",
                                            style: TextStyle(fontSize: 20)));
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }))),
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                                border: Border(right: BorderSide(width: 0.5))),
                            child: const Center(
                                child: Text("0",
                                    style: TextStyle(fontSize: 20))))),
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                                border: Border(right: BorderSide(width: 0.5))),
                            child: const Center(
                                child: Text("0",
                                    style: TextStyle(fontSize: 20))))),
                    const Expanded(
                        child: Center(
                            child: Text("0", style: TextStyle(fontSize: 20)))),
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
                      try {
                        return ListView.separated(
                            itemCount: retrievedTaskList!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditTask(
                                                      isDone:
                                                          retrievedTaskList![
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
                                                    )));
                                        setState(() {
                                          _refresh();
                                        });
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
                                          return alert(context);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      padding:
                                          const EdgeInsets.only(right: 28.0),
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.delete,
                                              color: Colors.white),
                                          Text("SİL",
                                              style: TextStyle(
                                                  color: Colors.white))
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
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        leading: const Icon(Icons.numbers),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PomodoroView(
                                                        task:
                                                            retrievedTaskList![
                                                                index],
                                                      )));
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
                      } catch (e) {
                        _refresh();
                      }
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
                    }
                    return const Center(child: CircularProgressIndicator());
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
                //ButtonsOnPressed().doneButton(context, taskLists()[0]);
                
                Navigator.pushNamed(context, '/done', arguments: taskLists()[0])
                    .then((_) {
                  _refresh();
                });
              },
            ),
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
    tasks = await service.retrieveTasks();
    retrievedTaskList = taskLists()[1];
    setState(() {});
  }

  List<dynamic> taskLists() {
    List<TaskModel> incompletedTasks = [];
    List<TaskModel> completedTasks = [];
    List newList = [];
    for (int i = 0; i < tasks!.length; i++) {
      if (tasks![i].isDone == false) {
        incompletedTasks.add(tasks![i]);
      } else {
        completedTasks.add(tasks![i]);
      }
    }
    newList.addAll([completedTasks, incompletedTasks]);
    return newList;
  }

  void _dismiss() {
    taskList = service.retrieveTasks();
  }

  Future<void> _initRetrieval() async {
    taskList = service.retrieveTasks();
    tasks = await service.retrieveTasks();
  }

  AlertDialog alert(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(Task().alertTitle),
      content: Text(Task().alertSubtitle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            Task().alertApprove,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: ProjectThemeOptions().backGroundColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            Task().alertReject,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: ProjectThemeOptions().backGroundColor),
          ),
        ),
      ],
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
    Navigator.pushNamed(context, '/person');
  }

  void searchButton() {}
  void homeButton() {}
  void timerButton() {}
  void doneButton(BuildContext context, List<TaskModel> completedTasks) {
    //Navigator.pushNamed(context, '/done', arguments: completedTasks);
  }

  void stackedBarButton() {}
}
