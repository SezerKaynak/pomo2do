import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/providers/tasks_provider.dart';
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
  List<TaskModel> deletedTasks = [];
  DatabaseService dbService = DatabaseService();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final providerOfTasks = Provider.of<TasksProvider>(context, listen: true);
    providerOfTasks.getTasks();
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
                                  future: providerOfTasks.taskList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<TaskModel>> snapshot) {
                                    if (snapshot.hasData
                                        //&& snapshot.data!.isNotEmpty
                                        ) {
                                      try {
                                        return Center(
                                            child: Text(
                                          providerOfTasks
                                              .getLengthofMap()
                                              .toString(),
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
                                  future: providerOfTasks.taskList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<TaskModel>> snapshot) {
                                    if (snapshot.hasData
                                        //&& snapshot.data!.isNotEmpty
                                        ) {
                                      try {
                                        return Center(
                                            child: Text(
                                          providerOfTasks
                                              .taskLists()[0]
                                              .length
                                              .toString(),
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
                onRefresh: providerOfTasks.refresh,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: providerOfTasks.taskList,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TaskModel>> snapshot) {
                      if (snapshot.hasData) {
                        try {
                          return providerOfTasks.retrievedTaskList!.isEmpty
                              ? const Center(child: Text(noActiveTask))
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  shrinkWrap: true,
                                  itemCount:
                                      providerOfTasks.retrievedTaskList!.length,
                                  itemBuilder: (context, index) {
                                    String key = providerOfTasks
                                        .retrievedTaskList!.keys
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
                                          itemCount: providerOfTasks
                                              .retrievedTaskList![key]!.length,
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
                                                      providerOfTasks.dismiss(
                                                          key, index);
                                                    } else {
                                                      {
                                                        Navigator.pushNamed(
                                                                context,
                                                                '/editTask',
                                                                arguments:
                                                                    providerOfTasks
                                                                            .retrievedTaskList![key]![
                                                                        index])
                                                            .then((_) =>
                                                                providerOfTasks
                                                                    .refresh());
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
                                                                      ))));
                                                        },
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        title: Text(providerOfTasks
                                                            .retrievedTaskList![
                                                                key]![index]
                                                            .taskName),
                                                        subtitle: Text(
                                                            providerOfTasks
                                                                .retrievedTaskList![
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
                          providerOfTasks.refresh();
                        }
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          providerOfTasks.retrievedTaskList!.isEmpty) {
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
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: "Archive"),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
            BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Trash")
          ],
          onTap: (selectedIndex) {
            switch (selectedIndex) {
              case 0:
                Navigator.pushNamed(
                  context,
                  '/archived',
                ).then((_) => providerOfTasks.refresh());

                break;
              case 1:
                Navigator.pushNamed(
                  context,
                  '/done',
                ).then((_) => providerOfTasks.refresh());

                break;
              case 2:
                Navigator.pushNamed(
                  context,
                  '/deleted',
                ).then((_) => providerOfTasks.refresh());

                break;
              default:
            }
          },
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
                  addButtonText,
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
}
