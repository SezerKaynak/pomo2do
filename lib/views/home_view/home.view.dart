import 'package:flutter/material.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/home_view/home.widgets.dart';
import 'package:pomotodo/views/home_view/widgets/bottom_navigation.dart';
import 'package:pomotodo/views/home_view/widgets/custom_drawer.dart';
import 'package:pomotodo/views/home_view/widgets/floating_buttons.dart';
import 'package:pomotodo/views/search_view/search.view.dart';

class HomeView extends StatelessWidget with HomeWidgets {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(L10n.of(context)!.pomoTodo,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
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
