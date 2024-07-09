import 'package:cloud_firestore/cloud_firestore.dart';
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

import 'home_screen.dart';

class RejectedTasks extends StatefulWidget {
  const RejectedTasks({Key? key}) : super(key: key);

  @override
  State<RejectedTasks> createState() => _RejectedTasksState();
}

class _RejectedTasksState extends State<RejectedTasks> {
  String userID = CacheHelper.getData(key: 'UserIDAdmin') ?? '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarApp(
          text: "Rejected tasks",
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
              .where('status_task', isEqualTo: 'Rejected tasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: loadingAppWidget());
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
                    nameSecretary: task['name'],
                    managerNote: task['note_admin'],
                    statusTask: task['status_task'],
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
