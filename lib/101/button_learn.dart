import 'package:flutter/material.dart';

class ButtonLearn extends StatelessWidget {
  const ButtonLearn({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
            onPressed: (){}, 
            child: const Text('Save')
          ),

          ElevatedButton(onPressed: (){}, child: const Text('Save')),
          IconButton(onPressed: (){}, icon: const Icon(Icons.abc_rounded)),
          FloatingActionButton.extended(
            onPressed: (){},
            label: const Text('Ekle'),
            icon: const Icon(Icons.add),
          ),
          
          OutlinedButton(onPressed: (){}, child: const Text('data')),
          OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.abc_outlined), label: const Text('data')),
          InkWell(onTap: (){}, child: const Text('data')),


          Container(
            height: 200,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))

            )),
            onPressed: () {},

            child: Padding(

              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 40, left: 40),
              child: Text('Place Bid', style: Theme.of(context).textTheme.headline5),
            )),
            
        ],
      ),

    );
  }
  
}