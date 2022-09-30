import 'package:flutter/material.dart';

class ListTileLearn extends StatelessWidget {
  const ListTileLearn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile( 
              title: Image.asset("assets/png/apple.png", height: 100, fit: BoxFit.cover),
              onTap: (){},
              subtitle: const Text("How do you use your card"),
              leading: Container(color: Colors.red, child: const Icon(Icons.money)),
              trailing: const SizedBox(width:20, child: Icon(Icons.chevron_right)),
            ),
          ),
        )

      ]),
    );
  }
}