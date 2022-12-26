import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home_view/home.widgets.dart';
import 'package:flutter_application_1/views/home_view/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/views/home_view/widgets/custom_drawer.dart';
import 'package:flutter_application_1/views/home_view/widgets/floating_buttons.dart';
import 'package:flutter_application_1/views/search_view/search.view.dart';

class HomeView extends StatelessWidget with HomeWidgets {
  const HomeView({Key? key}) : super(key: key);

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
      body: body(context),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FloatingButtons(),
    );
  }
}
