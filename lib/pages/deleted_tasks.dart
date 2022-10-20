import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DeletedTasks extends StatelessWidget {
  const DeletedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Çöp Kutusu"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("data")
      ),
    );
  }
}

class ListUpdate extends ChangeNotifier {
  List deletedTasks = [];

}
