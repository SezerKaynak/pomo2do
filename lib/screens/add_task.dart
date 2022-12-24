import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task_model.dart';
import 'package:flutter_application_1/providers/select_icon_provider.dart';
import 'package:flutter_application_1/screens/task.dart';
import 'package:flutter_application_1/service/database_service.dart';
import 'package:flutter_application_1/widgets/screen_text_field.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskTypeController;
  late TextEditingController _taskInfoController;

  @override
  void initState() {
    _taskNameController = TextEditingController();
    _taskTypeController = TextEditingController();
    _taskInfoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskTypeController.dispose();
    _taskInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textLabel2 = 'Görev adı';
    var textLabel3 = 'Görev türü';
    var textLabel4 = 'Görev açıklaması...';
    var buttonText = "Kaydet";

    DatabaseService dbService = DatabaseService();

    final selectedIcon = Provider.of<SelectIcon>(context, listen: true);
    List<IconData> iconData = selectedIcon.icons;
    List<Widget> icons = [];
    for(int i = 0; i < iconData.length; i++){
      icons.add(Icon(iconData[i]));
    }
    

    return Padding(
      padding: EdgeInsets.fromLTRB(
          15, 15, 15, MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
              flex: 0,
              child: Center(
                child: Text(
                  "Görev Ekle",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScreenTextField(
                      textLabel: textLabel2,
                      obscure: false,
                      controller: _taskNameController,
                      maxLines: 1),
                  ScreenTextField(
                      textLabel: textLabel3,
                      obscure: false,
                      controller: _taskTypeController,
                      maxLines: 1),
                  ScreenTextField(
                      textLabel: textLabel4,
                      obscure: false,
                      controller: _taskInfoController,
                      maxLines: 4),
                  RepaintBoundary(
                    child: ToggleButtons(
                      onPressed: (int index) {
                        selectedIcon.selectedIcon(index);
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      selectedBorderColor: Colors.blue[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.blue[200],
                      color: Colors.blue[400],
                      isSelected: selectedIcon.selectedWeather,
                      children: icons,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        TaskModel newTask = TaskModel();
                        newTask.taskName = _taskNameController.text;
                        newTask.taskType = _taskTypeController.text;
                        newTask.taskInfo = _taskInfoController.text;
                        newTask.taskIcon = selectedIcon.codePoint;
                        await dbService.addTask(newTask);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskView()));
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(70),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: Center(child: Text(buttonText)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
