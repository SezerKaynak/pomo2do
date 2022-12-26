// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/models/task_model.dart';
// import 'package:flutter_application_1/service/database_service.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   DatabaseService service = DatabaseService();
//   Future<List<TaskModel>>? taskList;
//   List<TaskModel>? retrievedTaskList;

//   @override
//   void initState() {
//     super.initState();
//     _initRetrieval();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text(widget.title)),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Expanded(
//               flex: 1,
//               child: Container(
//                 color: Colors.black45,
//                 height: 60,
//               )),
//           Expanded(
//             flex: 12,
//             child: RefreshIndicator(
//               onRefresh: _refresh,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: FutureBuilder(
//                   future: taskList,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<List<TaskModel>> snapshot) {
//                     if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                       return ListView.separated(
//                           itemCount: retrievedTaskList!.length,
//                           separatorBuilder: (context, index) => const SizedBox(
//                                 height: 10,
//                               ),
//                           itemBuilder: (context, index) {
//                             var doNothing;
//                             return Slidable(
//                               key: const ValueKey(0),
                              
//                               startActionPane: ActionPane(
                                
//                                   motion: const ScrollMotion(),
//                                   dismissible:
//                                       DismissiblePane(onDismissed: (){}),
//                                   children: [
//                                     SlidableAction(
                                      
//                                       onPressed: doNothing,
//                                       borderRadius: BorderRadius.circular(20),
//                                       backgroundColor: const Color(0xFF21B7CA),
//                                       foregroundColor: Colors.white,
//                                       icon: Icons.edit,
//                                       label: 'Düzenle',
//                                     )
//                                   ]),
//                               endActionPane: ActionPane(
//                                   motion: const ScrollMotion(),
//                                   dismissible:
//                                       DismissiblePane(onDismissed: () async {
//                                     await service.deleteTask(
//                                         retrievedTaskList![index]
//                                             .id
//                                             .toString());
//                                     _dismiss();
//                                   }),
//                                   children: [
//                                     SlidableAction(
//                                       onPressed: doNothing,
//                                       borderRadius: BorderRadius.circular(20),
//                                       backgroundColor: const Color(0xFFFE4A49),
//                                       foregroundColor: Colors.white,
//                                       icon: Icons.delete,
//                                       label: 'Sil',
                                      
//                                     )
//                                   ]),
//                               child: Center(child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.blueGrey[50],
//                                     borderRadius: BorderRadius.circular(16.0)),
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.all(15),
//                                   leading: const Icon(Icons.numbers),
//                                   onTap: () {
//                                     Navigator.pushNamed(context, "/edit",
//                                         arguments: retrievedTaskList![index]);
//                                   },
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                   title:
//                                       Text(retrievedTaskList![index].taskName),
//                                   subtitle:
//                                       Text(retrievedTaskList![index].taskInfo),
//                                   trailing: const Icon(Icons.arrow_right_sharp),
//                                 ),
//                               ),)

//                             );
//                           });
//                     } else if (snapshot.connectionState ==
//                             ConnectionState.done &&
//                         retrievedTaskList!.isEmpty) {
//                       return Center(
//                         child: ListView(
//                           children: const <Widget>[
//                             Align(
//                                 alignment: AlignmentDirectional.center,
//                                 child: Text('Görev bulunamadı!')),
//                           ],
//                         ),
//                       );
//                     } else {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _refresh() async {
//     taskList = service.retrieveTasks();
//     retrievedTaskList = await service.retrieveTasks();
//     setState(() {});
//   }

//   void _dismiss() {
//     taskList = service.retrieveTasks();
//   }

//   Future<void> _initRetrieval() async {
//     taskList = service.retrieveTasks();
//     retrievedTaskList = await service.retrieveTasks();
//   }
// }
