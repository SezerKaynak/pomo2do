import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ListUpdate extends ChangeNotifier {
  bool isLoading = false;
  DatabaseService dbService = DatabaseService();
  void checkBoxWorks(List selectedIndexes, int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
    notifyListeners();
  }

  void taskActivationButton(List selectedIndexes, List<TaskModel> tasks) async {
    int selectedNumber = selectedIndexes.length;
    selectedIndexes.sort();
    isLoading = true;
    notifyListeners();
    for (int i = 0; i < selectedNumber; i++) {
      final TaskModel data = tasks[selectedIndexes[i]];
      data.isActive = true;
      await dbService.updateTask(data);
    }

    for (int i = 0; i < selectedIndexes.length; i++) {
      tasks[selectedIndexes[i] - i].isDone
          ? SmartDialog.showToast(
              "${tasks[selectedIndexes[i - i]].taskName} görevi tamamlanmış görevler sayfasına taşındı!")
          : SmartDialog.showToast(
              "${tasks[selectedIndexes[i - i]].taskName} görevi görevler sayfasına taşındı!");
      tasks.removeAt(selectedIndexes[i] - i);
    }
    selectedIndexes.clear();
    isLoading = false;
    notifyListeners();
  }

  void deleteTasksButton(List selectedIndexes, List<TaskModel> tasks) async {
    int selectedNumber = selectedIndexes.length;
    selectedIndexes.sort();
    for (int i = 0; i < selectedNumber; i++) {
      await dbService.deleteTask(tasks[selectedIndexes[i]].id.toString());
    }

    for (int i = 0; i < selectedIndexes.length; i++) {
      tasks.removeAt(selectedIndexes[i] - i);
    }
    selectedIndexes.clear();
    notifyListeners();
  }
}
