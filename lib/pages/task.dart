import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pomotodo_user.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/pages/add_task.dart';
import 'package:flutter_application_1/pages/edit_password.dart';
import 'package:flutter_application_1/pages/edit_task.dart';
import 'package:flutter_application_1/pages/pomodoro.dart';
import 'package:flutter_application_1/pages/pomodoro_settings.dart';
import 'package:flutter_application_1/pages/search_view.dart';
import 'package:flutter_application_1/project_theme_options.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_application_1/service/i_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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
  String? downloadUrl;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    String yol = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(context.read<PomotodoUser>().userId)
        .child("profilResmi.png")
        .getDownloadURL();

    setState(() {
      downloadUrl = yol;
    });
  }

  String alertTitle = "Görev Çöp Kutusuna Taşınacak!";
  String alertSubtitle = "Görev çöp kutusuna taşınsın mı?";
  String alertApprove = "Onayla";
  String alertReject = "İptal Et";
  String alertTitleLogOut = "Çıkış Yapılacak!";
  String alertSubtitleLogOut = "Çıkış yapmak istediğinizden emin misiniz?";
  String alertApproveLogOut = "Onayla";
  String alertRejectLogOut = "İptal Et";
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    var user = users.doc(context.read<PomotodoUser>().userId);
    var _authService = Provider.of<IAuthService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            systemOverlayStyle: ProjectThemeOptions().systemTheme,
            backgroundColor: ProjectThemeOptions().backGroundColor,
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
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.745,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: 50.0,
                                  child: downloadUrl != null
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: downloadUrl!,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return ClipOval(
                                                child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        50),
                                                    child: Image(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover)));
                                          },
                                          placeholder: (context, url) {
                                            return ClipOval(
                                                child: SizedBox.fromSize(
                                              size: const Size.fromRadius(20),
                                              child:
                                                  const CircularProgressIndicator(
                                                      color: Colors.white),
                                            ));
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : ClipOval(
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(70),
                                            child: Image.asset(
                                              'assets/person.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: StreamBuilder(
                                      stream: user.snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot asyncSnapshot) {
                                        if (asyncSnapshot.hasError) {
                                          return const Text(
                                              "Bir şeyler yanlış gitti");
                                        } else if (asyncSnapshot.hasData &&
                                            !asyncSnapshot.data!.exists) {
                                          return const Text(
                                            "Hesap ayarları sayfasından profil resmi seçebilirsiniz",
                                            overflow: TextOverflow.clip,
                                            maxLines: 3,
                                          );
                                        } else if (asyncSnapshot
                                                .connectionState ==
                                            ConnectionState.active) {
                                          return Text(
                                            "${asyncSnapshot.data.data()["name"]}"
                                            " ${asyncSnapshot.data.data()["surname"]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 26,
                                                    color: Colors.black),
                                          );
                                        }
                                        return const Text("Loading");
                                      }),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  )),
              Settings(
                settingIcon: Icons.account_circle,
                title: settingTitle(context, "Hesap Ayarları"),
                subtitle: "Profilinizi düzenleyebilirsiniz.",
                tap: () {
                  Navigator.pushNamed(context, '/editProfile');
                },
              ),
              const Divider(thickness: 1),
              Settings(
                settingIcon: Icons.password,
                subtitle: "Şifrenizi değiştirebilirsiniz.",
                title: settingTitle(context, 'Şifreyi Değiştir'),
                tap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditPassword()));
                },
              ),
              const Divider(thickness: 1),
              Settings(
                  settingIcon: Icons.notifications,
                  subtitle: "Bildirim ayarlarını yapabilirsiniz.",
                  title: settingTitle(context, 'Bildirim Ayarları'),
                  tap: () {}),
              const Divider(thickness: 1),
              Settings(
                  settingIcon: Icons.watch,
                  subtitle: "Pomodoro sayacı vb. ayarları yapabilirsiniz.",
                  title: settingTitle(context, 'Pomodoro Ayarları'),
                  tap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PomodoroSettings()));
                  }),
              const Divider(thickness: 1),
              Settings(
                  settingIcon: Icons.logout,
                  subtitle: "Hesaptan çıkış yapın.",
                  title: settingTitle(context, 'Çıkış Yap'),
                  tap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            title: Text(alertTitleLogOut),
                            content: Text(alertSubtitleLogOut),
                            actions: [
                              TextButton(
                                onPressed: () async =>
                                    await _authService.signOut(),
                                child: Text(
                                  alertApproveLogOut,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          color: ProjectThemeOptions()
                                              .backGroundColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  alertReject,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          color: ProjectThemeOptions()
                                              .backGroundColor),
                                ),
                              ),
                            ],
                          );
                        });
                  }),
              const Divider(thickness: 1),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.cyan[100],
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
                                            child: CircularProgressIndicator());
                                      }
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
                                            child: CircularProgressIndicator());
                                      }
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
                                  child: Text("Aktif görev bulunamadı!"))
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
                                            return Dismissible(
                                                onDismissed:
                                                    ((direction) async {
                                                  if (direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                    CollectionReference users =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Users/${context.read<PomotodoUser>().userId}/tasks');
                                                    var task = users.doc(
                                                        retrievedTaskList![
                                                                key]![index]
                                                            .id);
                                                    task.set({
                                                      'taskNameCaseInsensitive':
                                                          retrievedTaskList![
                                                                  key]![index]
                                                              .taskName
                                                              .toLowerCase(),
                                                      'taskName':
                                                          retrievedTaskList![
                                                                  key]![index]
                                                              .taskName,
                                                      'taskType':
                                                          retrievedTaskList![
                                                                  key]![index]
                                                              .taskType,
                                                      'taskInfo':
                                                          retrievedTaskList![
                                                                  key]![index]
                                                              .taskInfo,
                                                      "isDone": false,
                                                      "isActive": false,
                                                      "isArchive": false,
                                                    });

                                                    _refresh();
                                                    _dismiss();
                                                  } else {
                                                    {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      EditTask(
                                                                        isArchive:
                                                                            retrievedTaskList![key]![index].isArchive,
                                                                        isDone:
                                                                            retrievedTaskList![key]![index].isDone,
                                                                        taskInfo:
                                                                            retrievedTaskList![key]![index].taskInfo,
                                                                        taskName:
                                                                            retrievedTaskList![key]![index].taskName,
                                                                        taskType:
                                                                            retrievedTaskList![key]![index].taskType,
                                                                        id: retrievedTaskList![key]![index]
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
                                                    (DismissDirection
                                                        direction) async {
                                                  if (direction ==
                                                      DismissDirection
                                                          .endToStart) {
                                                    return await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return alert(context);
                                                      },
                                                    );
                                                  }
                                                  return true;
                                                },
                                                background: Container(
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF21B7CA),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
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
                                                          color: Colors.white),
                                                      Text(
                                                        "DÜZENLE",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                secondaryBackground: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    16.0)),
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                            color:
                                                                Colors.white),
                                                        Text(
                                                            "ÇÖP KUTUSUNA TAŞI",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    )),
                                                resizeDuration: const Duration(
                                                    milliseconds: 200),
                                                key: UniqueKey(),
                                                child: Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.blueGrey[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    16.0)),
                                                    child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      leading: const Icon(
                                                          Icons.numbers),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChangeNotifierProvider<
                                                                            PageUpdate>(
                                                                        create:
                                                                            (context) {
                                                                          return PageUpdate();
                                                                        },
                                                                        child:
                                                                            PomodoroView(
                                                                          task:
                                                                              retrievedTaskList![key]![index],
                                                                        ))));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
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
                                                ));
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
                  taskIcons: Icons.archive,
                  onPressIconButton: () {
                    Navigator.pushNamed(context, '/archived',
                            arguments: taskLists()[3])
                        .then((_) => _refresh());
                  }),
              TaskPageIconButton(
                taskIcons: Icons.done,
                onPressIconButton: () {
                  Navigator.pushNamed(context, '/done',
                          arguments: taskLists()[0])
                      .then((_) {
                    _refresh();
                  });
                },
              ),
              TaskPageIconButton(
                  taskIcons: Icons.delete,
                  onPressIconButton: () {
                    Navigator.pushNamed(context, '/deleted',
                            arguments: taskLists()[2])
                        .then((_) => _refresh());
                  }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  Navigator.pushNamed(context, '/deneme');
                },
                child: const Icon(Icons.stacked_bar_chart),
              ),
              const Spacer(),
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
                      ?.copyWith(color: Colors.white),
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

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
    required this.settingIcon,
    required this.subtitle,
    required this.title,
    required this.tap,
  }) : super(key: key);

  final IconData settingIcon;
  final String subtitle;
  final Widget title;
  final Function() tap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              settingIcon,
              size: 40,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [title, const Icon(Icons.arrow_right_sharp)],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
