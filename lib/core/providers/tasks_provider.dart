import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:pomotodo/core/service/database_service.dart';
import '../models/task_model.dart';

class TasksProvider extends ChangeNotifier {
  DatabaseService service = DatabaseService();
  Future<List<TaskModel>>? taskList;
  Map<String, List<TaskModel>>? retrievedTaskList;
  List<TaskModel>? tasks;
  DatabaseService dbService = DatabaseService();

  Future<void> getTasks() async {
    taskList = service.retrieveTasks();
    tasks = await service.retrieveTasks();
    retrievedTaskList = separateLists(taskLists()[1]);
  }
  
  Future<void> refresh() async {
    taskList = service.retrieveTasks();
    notifyListeners();
  }
  
  void dismiss(String key, int index) {
    retrievedTaskList![key]![index].isActive = false;
    dbService.updateTask(retrievedTaskList![key]![index]);
    retrievedTaskList![key]!.removeAt(index);
    notifyListeners();
  }

  Map<String, List<TaskModel>> separateLists(List<TaskModel> tasks) {
    final groups = groupBy(tasks, (TaskModel e) {
      return e.taskType;
    });
    var sortedByKeyMap = Map.fromEntries(groups.entries.toList()
      ..sort((e1, e2) => e1.key.toLowerCase().compareTo(e2.key.toLowerCase())));

    return sortedByKeyMap;
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
}
