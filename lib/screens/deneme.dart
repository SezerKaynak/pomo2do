import 'package:flutter/material.dart';
import 'package:flutter_application_1/assets/constants.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/providers/tasks_provider.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_application_1/widgets/task_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class TaskDeneme extends StatefulWidget {
  const TaskDeneme({super.key});

  @override
  State<TaskDeneme> createState() => _TaskDenemeState();
}

class _TaskDenemeState extends State<TaskDeneme> {
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final providerOfTasks = Provider.of<TasksProvider>(context, listen: true);
    providerOfTasks.getTasks();
    return Scaffold(
        appBar: AppBar(
          title: const Text("PomoTodo"),
          centerTitle: true,
          leading: const Icon(Icons.menu_rounded),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: FutureBuilder(
          future: providerOfTasks.taskList,
          builder:
              (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
            if (snapshot.hasData) {
              try {
                return providerOfTasks.retrievedTaskList!.isEmpty
                    ? const Center(
                        child: Text(noActiveTask),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        shrinkWrap: true,
                        itemCount: providerOfTasks.retrievedTaskList!.length,
                        itemBuilder: (context, index) {
                          String key = providerOfTasks.retrievedTaskList!.keys
                              .elementAt(index);
                          return Column(
                            children: [
                              Text(key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                shrinkWrap: true,
                                itemCount: providerOfTasks
                                    .retrievedTaskList![key]!.length,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          providerOfTasks.dismiss(key, index);
                                        } else {
                                          Navigator.pushNamed(
                                              context, '/editTask',
                                              arguments: providerOfTasks
                                                      .retrievedTaskList![key]![
                                                  index]);
                                        }
                                      },
                                      confirmDismiss:
                                          (DismissDirection direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          return await QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            title: alertTitle,
                                            text: alertSubtitle,
                                            confirmBtnText: alertApprove,
                                            cancelBtnText: alertReject,
                                            confirmBtnColor:
                                                Theme.of(context).errorColor,
                                            onConfirmBtnTap: () =>
                                                Navigator.of(context).pop(true),
                                            onCancelBtnTap: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          );
                                        }
                                        return true;
                                      },
                                      child: Center(
                                          child: Container(
                                        color: Theme.of(context).cardColor,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          leading: const Icon(Icons.numbers),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          title: Text(providerOfTasks
                                              .retrievedTaskList![key]![index]
                                              .taskName),
                                          subtitle: Text(providerOfTasks
                                              .retrievedTaskList![key]![index]
                                              .taskInfo),
                                        ),
                                      )),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
              } catch (e) {}
            } else if (snapshot.connectionState == ConnectionState.done &&
                providerOfTasks.retrievedTaskList!.isEmpty) {
              return Center(
                child: ListView(
                  children: const [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(noTask),
                    )
                  ],
                ),
              );
            }
            return const TaskShimmer();
          },
        ));
  }
}
