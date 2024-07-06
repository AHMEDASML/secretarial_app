import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:secretarial_app/administration/add_secretary/screen/add_secretary.dart';
import 'package:secretarial_app/administration/all_secretarial/screen/all_secretarial.dart';
import 'package:secretarial_app/administration/edite_task/screen/edite_tasks.dart';
import 'package:secretarial_app/global/common/functions_app.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/components/appBar_app.dart';
import 'package:secretarial_app/global/components/no_data_widget.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:secretarial_app/secretariat/add_task/screen/add_task_screen.dart';

class HomeAdministrationScreen extends StatefulWidget {
  const HomeAdministrationScreen({Key? key}) : super(key: key);

  @override
  State<HomeAdministrationScreen> createState() =>
      _HomeAdministrationScreenState();
}

class _HomeAdministrationScreenState extends State<HomeAdministrationScreen> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  @override
  void initState() {
    super.initState();
    _configureFirebaseListeners();
  }

  void _configureFirebaseListeners() {
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: ${message.notification}');

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: ${message.notification}');

    });

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: $token");

    });
  }





  @override
  Widget build(BuildContext context) {
    String userID = CacheHelper.getData(key: 'UserIDAdmin') ?? '';
    print(userID);
    return Scaffold(
      appBar: appBarApp(
          text: "Manager's tasks",
          widget: GestureDetector(
            onTap: () {
              navigateTo(context, const AllSecretarial());
            },
            child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorManager.white)),
                child: const Icon(Icons.perm_identity_rounded)),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        child: const Icon(Icons.add),
        onPressed: () {
          navigateTo(context, const AddSecretary());
        },
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where('UserIDAdmin', isEqualTo: userID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return   Center(child: loadingAppWidget());
            }

            var tasks = snapshot.data!.docs;

            if (tasks.isEmpty) {
              return const NoDataWidget();
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return GestureDetector(

                  onTap: () {
                    navigateTo(
                      context,
                      EditeTasks(
                        taskId: task.id,
                        taskData: task.data() as Map<String, dynamic>,
                      ),
                    );
                  },

                  child: AppointmentItem(
                    title: task['title'],
                    details: task['subtitle'],
                    dateTime: DateTime.parse(task['dateTime']),
                    importance: task['importance'] ?? 'No Importance',

                    nameSecretary: task['name'], managerNote: task['note_admin'],

                  ),
                );
              },
            );
          },
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
  final String managerNote;

  const AppointmentItem({
    Key? key,
    required this.title,
    required this.details,
    required this.dateTime,
    required this.nameSecretary,
    required this.importance, required this.managerNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
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
                  "Secretary's name : $nameSecretary",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
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


                  Text(
                  "Manager's Note : $managerNote",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
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


