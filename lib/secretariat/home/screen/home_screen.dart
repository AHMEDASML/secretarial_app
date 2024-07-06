import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretarial_app/global/common/functions_app.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/components/appBar_app.dart';
import 'package:secretarial_app/global/components/no_data_widget.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:secretarial_app/secretariat/add_task/screen/add_task_screen.dart';

class HomeScreenSecretariat extends StatefulWidget {
  const HomeScreenSecretariat({Key? key}) : super(key: key);

  @override
  State<HomeScreenSecretariat> createState() => _HomeScreenSecretariatState();
}

class _HomeScreenSecretariatState extends State<HomeScreenSecretariat> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> navigateToAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTask()),
    );
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final String email = CacheHelper.getData(key: 'emailSecretary');
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('tasks')
              .where('emailSecretary', isEqualTo: email)
              .get();
      final List<Map<String, dynamic>> fetchedTasks =
          snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarApp(
          text: 'Home Secretariat',
          widget: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorManager.white)),
              child: const Icon(Icons.perm_identity_rounded))),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        onPressed: navigateToAddTask,
        child: const Icon(Icons.task_outlined,),
      ),
      body: Container(

        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
              Color.fromRGBO(184, 187, 255, 0.6),
            ])),
        child: isLoading
            ?   Center(child: loadingAppWidget())
            : tasks.isEmpty
                ? const NoDataWidget()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        ...tasks.map((task) {
                          final dateTime = task['dateTime'] is Timestamp
                              ? (task['dateTime'] as Timestamp).toDate()
                              : DateTime.tryParse(task['dateTime'] ?? '') ??
                                  DateTime.now();

                          return AppointmentItem(
                            title: task['title'] ?? 'No Title',
                            details: task['subtitle'] ?? 'No Details',
                            dateTime: dateTime,
                            nameSecretary: task['name'] ?? 'No Name',
                            importance: task['importance'] ?? 'No Importance',
                          );
                        }).toList(),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class AppointmentItem extends StatelessWidget {
  final String title;
  final String details;
  final DateTime dateTime;
  final String nameSecretary;
  final String importance;

  const AppointmentItem({
    Key? key,
    required this.title,
    required this.details,
    required this.dateTime,
    required this.nameSecretary,
    required this.importance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(

        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: const Color.fromRGBO(132, 139, 218, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Time: ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Name of the secretary : $nameSecretary',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'Importance : $importance',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _getImportanceColor(importance),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getImportanceColor(String importance) {
    switch (importance) {
      case 'weak':
        return Colors.yellow;
      case 'Important':
        return Colors.red;
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}