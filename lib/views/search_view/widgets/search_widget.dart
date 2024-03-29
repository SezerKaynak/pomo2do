import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:pomotodo/core/models/pomotodo_user.dart';
import 'package:pomotodo/core/models/task_model.dart';
import 'package:pomotodo/utils/constants/constants.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<PomotodoUser>(context, listen: false).userId;
    return FirestoreSearchScaffold(
      pressed: () {
        Navigator.pop(context);
      },
      searchTextHintColor: Colors.black,
      searchTextColor: Colors.black,
      searchBodyBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      firestoreCollectionName: 'Users/$user/tasks',
      searchBy: 'taskNameCaseInsensitive',
      dataListFromSnapshot: TaskModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TaskModel>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text(noResult),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final TaskModel data = dataList[index];
              return Container(
                decoration: BoxDecoration(
                    color: getColor(data, context),
                    borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: const Icon(Icons.numbers),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) {
                              return PageUpdate(context: context);
                            },
                            child: PomodoroWidget(
                              task: dataList[index],
                            ),
                          ),
                        ));
                  },
                  title: Text(data.taskName),
                  subtitle: Text(data.taskInfo),
                  trailing: const Icon(Icons.arrow_right_sharp),
                ),
              );
            },
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(noResult),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  getColor(TaskModel data, BuildContext context) {
    if (data.isDone && data.isActive && data.isArchive) {
      return Colors.cyan[300];
    } else if (data.isDone && data.isActive && !data.isArchive) {
      return Colors.green[500];
    } else if (!data.isDone && !data.isActive && !data.isArchive) {
      return Colors.red[400];
    } else if (data.isDone && !data.isActive && !data.isArchive) {
      return Colors.red[400];
    } else if (!data.isDone && data.isActive && data.isArchive) {
      return Colors.cyan[200];
    } else if (!data.isDone && data.isActive && !data.isArchive) {
      return Theme.of(context).cardColor;
    }
  }
}
