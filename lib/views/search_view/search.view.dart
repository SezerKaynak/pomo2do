import 'package:flutter/material.dart';
import 'package:pomotodo/views/search_view/search.widgets.dart';

class SearchView extends StatelessWidget with SearchWidgets {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }
}
