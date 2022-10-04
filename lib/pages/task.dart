import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/add_task.dart';
import 'package:flutter_application_1/pages/edit_task.dart';
import 'package:flutter_application_1/pages/person_info.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
              searchFieldDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
              backIcon: Icons.tune,
              centerTitleStyle: const TextStyle(color: Colors.white, fontSize: 18),
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
                            return Slidable(
                                key: const ValueKey(0),
                                startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible: DismissiblePane(
                                        key: UniqueKey(),
                                        resizeDuration:
                                            const Duration(milliseconds: 200),
                                        onDismissed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTask(
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
                                                      )),
                                              ModalRoute.withName("/EditTask"));
                                        }),
                                    children: [
                                      SlidableAction(
                                        onPressed:
                                            (context) =>
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                EditTask(
                                                                  isDone: retrievedTaskList![
                                                                          index]
                                                                      .isDone,
                                                                  taskInfo: retrievedTaskList![
                                                                          index]
                                                                      .taskInfo,
                                                                  taskName: retrievedTaskList![
                                                                          index]
                                                                      .taskName,
                                                                  taskType: retrievedTaskList![
                                                                          index]
                                                                      .taskType,
                                                                  id: retrievedTaskList![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                )),
                                                    ModalRoute.withName(
                                                        "/EditTask")),
                                        borderRadius: BorderRadius.circular(20),
                                        backgroundColor:
                                            const Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Düzenle',
                                      )
                                    ]),
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible: DismissiblePane(
                                        key: UniqueKey(),
                                        resizeDuration:
                                            const Duration(milliseconds: 200),
                                        onDismissed: () async {
                                          await service.deleteTask(
                                              retrievedTaskList![index]
                                                  .id
                                                  .toString());
                                          _dismiss();
                                        }),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) => () async {
                                          await service.deleteTask(
                                              retrievedTaskList![index]
                                                  .id
                                                  .toString());
                                          _dismiss();
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Sil',
                                      )
                                    ]),
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
                                        Navigator.pushNamed(context, "/edit",
                                            arguments:
                                                retrievedTaskList![index]);
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

  const TaskAdded({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTouch
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    // CollectionReference tasks = FirebaseFirestore.instance
    //     .collection('Users/${FirebaseAuth.instance.currentUser!.uid}/tasks');
    // var task = tasks.doc("0HyIqs5QvSFQquZ3Siyt");
    // var doNothing;
    // return Slidable(
    //   key: const ValueKey(0),
    //   startActionPane: ActionPane(
    //     motion: const ScrollMotion(),
    //     dismissible: DismissiblePane(onDismissed: () {}),
    //     children: [
    //       SlidableAction(
    //         borderRadius: BorderRadius.circular(20),
    //         onPressed: doNothing,
    //         backgroundColor: const Color(0xFF21B7CA),
    //         foregroundColor: Colors.white,
    //         icon: Icons.edit,
    //         label: 'Düzenle',
    //       ),
    //     ],
    //   ),
    //   endActionPane: ActionPane(
    //     motion: const ScrollMotion(),
    //     dismissible: DismissiblePane(onDismissed: () {}),
    //     children: [
    //       SlidableAction(
    //         borderRadius: BorderRadius.circular(20),
    //         onPressed: doNothing,
    //         backgroundColor: const Color(0xFFFE4A49),
    //         foregroundColor: Colors.white,
    //         icon: Icons.delete,
    //         label: 'Sil',
    //       ),
    //     ],
    //   ),
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
