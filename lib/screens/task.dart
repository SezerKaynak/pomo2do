import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/screens/add_task.dart';
import 'package:flutter_application_1/screens/pomodoro.dart';
import 'package:flutter_application_1/screens/search_view.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/widgets/custom_drawer.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_application_1/providers/pomodoro_provider.dart';
import 'package:flutter_application_1/widgets/task_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_application_1/assets/constants.dart';

class TaskView extends StatefulWidget with ProjectThemeOptions {
  TaskView({Key? key}) : super(key: key);

  @override
  State<TaskView> createState() => Task();
}

class Task extends State<TaskView> {
  DatabaseService service = DatabaseService();
  Future<List<TaskModel>>? taskList;
  Map<String, List<TaskModel>>? retrievedTaskList;
  List<TaskModel>? tasks;
  final TextEditingController textController = TextEditingController();
  List<TaskModel> deletedTasks = [];
  DatabaseService dbService = DatabaseService();
  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("PomoTodo",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            leading: Builder(
                builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu_rounded))),
            centerTitle: true,
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
        drawer: const CustomDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                  border:
                                      Border(right: BorderSide(width: 0.5))),
                              child: FutureBuilder(
                                  future: taskList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<TaskModel>> snapshot) {
                                    if (snapshot.hasData
                                        //&& snapshot.data!.isNotEmpty
                                        ) {
                                      try {
                                        return Center(
                                            child: Text(
                                          getLengthofMap().toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ));
                                      } catch (e) {
                                        return const Center(
                                            child: RepaintBoundary(
                                                child:
                                                    CircularProgressIndicator()));
                                      }
                                    } else if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        retrievedTaskList!.isEmpty) {
                                      return const Center(
                                          child: Text("0",
                                              style: TextStyle(fontSize: 20)));
                                    }
                                    return const Center(
                                        child: RepaintBoundary(
                                            child:
                                                CircularProgressIndicator()));
                                  }))),
                      Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                  border:
                                      Border(right: BorderSide(width: 0.5))),
                              child: FutureBuilder(
                                  future: taskList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<TaskModel>> snapshot) {
                                    if (snapshot.hasData
                                        //&& snapshot.data!.isNotEmpty
                                        ) {
                                      try {
                                        return Center(
                                            child: Text(
                                          taskLists()[0].length.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ));
                                      } catch (e) {
                                        return const Center(
                                            child: RepaintBoundary(
                                                child:
                                                    CircularProgressIndicator()));
                                      }
                                    } else if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        retrievedTaskList!.isEmpty) {
                                      return const Center(
                                          child: Text("0",
                                              style: TextStyle(fontSize: 20)));
                                    }
                                    return const Center(
                                        child: RepaintBoundary(
                                            child:
                                                CircularProgressIndicator()));
                                  }))),
                      Expanded(
                          child: Container(
                              decoration: const BoxDecoration(
                                  border:
                                      Border(right: BorderSide(width: 0.5))),
                              child: const Center(
                                  child: Text("0",
                                      style: TextStyle(fontSize: 20))))),
                      const Expanded(
                          child: Center(
                              child:
                                  Text("0", style: TextStyle(fontSize: 20)))),
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
                      if (snapshot.hasData) {
                        try {
                          return retrievedTaskList!.isEmpty
                              ? const Center(
                                  child: Text(noActiveTask))
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  shrinkWrap: true,
                                  itemCount: retrievedTaskList!.length,
                                  itemBuilder: (context, index) {
                                    String key = retrievedTaskList!.keys
                                        .elementAt(index);
                                    return Column(
                                      children: [
                                        Text(key,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        ListView.separated(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                          shrinkWrap: true,
                                          itemCount:
                                              retrievedTaskList![key]!.length,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: Dismissible(
                                                  onDismissed:
                                                      ((direction) async {
                                                    if (direction ==
                                                        DismissDirection
                                                            .endToStart) {
                                                      retrievedTaskList![key]![
                                                              index]
                                                          .isActive = false;
                                                      dbService.updateTask(
                                                          retrievedTaskList![
                                                              key]![index]);

                                                      _refresh();
                                                      _dismiss();
                                                    } else {
                                                      {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/editTask',
                                                            arguments:
                                                                retrievedTaskList![
                                                                        key]![
                                                                    index]);

                                                        setState(() {
                                                          _refresh();
                                                        });
                                                      }
                                                    }
                                                  }),
                                                  confirmDismiss:
                                                      (DismissDirection
                                                          direction) async {
                                                    if (direction ==
                                                        DismissDirection
                                                            .endToStart) {
                                                      return await QuickAlert
                                                          .show(
                                                        context: context,
                                                        type: QuickAlertType
                                                            .confirm,
                                                        title: alertTitle,
                                                        text: alertSubtitle,
                                                        confirmBtnText:
                                                            alertApprove,
                                                        cancelBtnText:
                                                            alertReject,
                                                        confirmBtnColor:
                                                            Theme.of(context)
                                                                .errorColor,
                                                        onConfirmBtnTap: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                        onCancelBtnTap: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                      );
                                                    }
                                                    return true;
                                                  },
                                                  background: Container(
                                                    color:
                                                        const Color(0xFF21B7CA),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 28.0),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.white),
                                                        Text(
                                                          editText,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  secondaryBackground:
                                                      Container(
                                                          color: Colors.red,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 28.0),
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .centerEnd,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(Icons.delete,
                                                                  color: Colors
                                                                      .white),
                                                              Text(
                                                                  moveIntoTrash,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white))
                                                            ],
                                                          )),
                                                  resizeDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  key: UniqueKey(),
                                                  child: Center(
                                                    child: Container(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      child: ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(15),
                                                        leading: const Icon(
                                                            Icons.numbers),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ChangeNotifierProvider<
                                                                          PageUpdate>(
                                                                      create:
                                                                          (context) {
                                                                        return PageUpdate();
                                                                      },
                                                                      child:
                                                                          PomodoroView(
                                                                        task: retrievedTaskList![key]![
                                                                            index],
                                                                      )))).then(
                                                              (_) =>
                                                                  _refresh());
                                                        },
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        title: Text(
                                                            retrievedTaskList![
                                                                    key]![index]
                                                                .taskName),
                                                        subtitle: Text(
                                                            retrievedTaskList![
                                                                    key]![index]
                                                                .taskInfo),
                                                        trailing: const Icon(Icons
                                                            .arrow_right_sharp),
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  });
                        } catch (e) {
                          _refresh();
                        }
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          retrievedTaskList!.isEmpty) {
                        return Center(
                          child: ListView(
                            children: const [
                              Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(noTask)),
                            ],
                          ),
                        );
                      }
                      return const TaskShimmer();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: "Archive"),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
            BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Trash")
          ],
          onTap: onItemTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  Navigator.pushNamed(context, '/deneme');
                },
                child: const Icon(Icons.stacked_bar_chart),
              ),
              FloatingActionButton.extended(
                heroTag: "btn2",
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
                      ?.copyWith(color: Colors.black),
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ));
  }

  Text settingTitle(BuildContext context, String textTitle) => Text(
        textTitle,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.w400, fontSize: 18),
      );
  Future<void> _refresh() async {
    taskList = service.retrieveTasks();
    tasks = await service.retrieveTasks();
    retrievedTaskList = separateLists(taskLists()[1]);
    setState(() {});
  }

  List<dynamic> taskLists() {
    List<TaskModel> incompletedTasks = [];
    List<TaskModel> completedTasks = [];
    List<TaskModel> trashBoxTasks = [];
    List<TaskModel> archivedTasks = [];
    List newList = [];
    for (int i = 0; i < tasks!.length; i++) {
      if (tasks![i].isDone && tasks![i].isActive && tasks![i].isArchive) {
        archivedTasks.add(tasks![i]);
      } else if (tasks![i].isDone &&
          tasks![i].isActive &&
          !tasks![i].isArchive) {
        completedTasks.add(tasks![i]);
      } else if (!tasks![i].isDone &&
          !tasks![i].isActive &&
          !tasks![i].isArchive) {
        trashBoxTasks.add(tasks![i]);
      } else if (tasks![i].isDone &&
          !tasks![i].isActive &&
          !tasks![i].isArchive) {
        trashBoxTasks.add(tasks![i]);
      } else if (!tasks![i].isDone &&
          tasks![i].isActive &&
          tasks![i].isArchive) {
        archivedTasks.add(tasks![i]);
      } else if (!tasks![i].isDone &&
          tasks![i].isActive &&
          !tasks![i].isArchive) {
        incompletedTasks.add(tasks![i]);
      }
    }
    newList.addAll(
        [completedTasks, incompletedTasks, trashBoxTasks, archivedTasks]);
    return newList;
  }

  Map<String, List<TaskModel>> separateLists(List<TaskModel> tasks) {
    final groups = groupBy(tasks, (TaskModel e) {
      return e.taskType;
    });
    var sortedByKeyMap = Map.fromEntries(groups.entries.toList()
      ..sort((e1, e2) => e1.key.toLowerCase().compareTo(e2.key.toLowerCase())));

    return sortedByKeyMap;
  }

  getLengthofMap() {
    int count = 0;
    for (int i = 0; i < retrievedTaskList!.length; i++) {
      String key = retrievedTaskList!.keys.elementAt(i);
      for (int j = 0; j < retrievedTaskList![key]!.length; j++) {
        count += 1;
      }
    }
    return count;
  }

  void onItemTapped(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        Navigator.pushNamed(context, '/archived', arguments: taskLists()[3])
            .then((_) => _refresh());

        break;
      case 1:
        Navigator.pushNamed(context, '/done', arguments: taskLists()[0])
            .then((_) {
          _refresh();
        });

        break;
      case 2:
        Navigator.pushNamed(context, '/deleted', arguments: taskLists()[2])
            .then((_) => _refresh());

        break;
      default:
    }
  }

  void _dismiss() {
    taskList = service.retrieveTasks();
  }

  Future<void> _initRetrieval() async {
    taskList = service.retrieveTasks();
    tasks = await service.retrieveTasks();
  }
}
