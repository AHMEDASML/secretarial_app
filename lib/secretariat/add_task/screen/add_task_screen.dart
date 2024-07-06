import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:secretarial_app/global/common/loading_app.dart';

import 'package:secretarial_app/global/components/appBar_app.dart';
import 'package:secretarial_app/global/components/button_app.dart';
import 'package:secretarial_app/global/components/text_app_bold.dart';
import 'package:secretarial_app/global/components/text_field_app.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:http/http.dart' as http;
class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  String _importance = 'normal';
  bool _isLogin = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarApp(text: 'Add Task'),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
              Color.fromRGBO(184, 187, 255, 0.6),
            ])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: textBold(
                    text: 'Task title',
                    color: ColorManager.white,
                    sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFieldApp(
                  controller: _titleController,
                  hintText: 'Main title',
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                  suffixIcon: Container(),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the main address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: textBold(
                    text: 'Subtask title',
                    color: ColorManager.white,
                    sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFieldApp(
                  controller: _subtitleController,
                  hintText: 'Subtitle',
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                  suffixIcon: Container(),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subtitle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: textBold(
                    text: 'Select date',
                    color: ColorManager.white,
                    sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(18, 17, 28, 0.4),
                            blurRadius: 10.0,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(195, 197, 255, 1.0),
                    ),
                    child: TextFormField(
                      controller: _dateTimeController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                          // Custom color border
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                          // Custom color border
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        suffixIconColor: const Color.fromRGBO(143, 148, 251, 1),
                        prefixIconColor: const Color.fromRGBO(143, 148, 251, 1),
                        // filled: true,
                        fillColor: const Color.fromRGBO(184, 187, 255, 0.6),
                        // Custom background color
                        hintText: 'Select date and time',
                        hintStyle:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                final now = DateTime.now();
                                final dateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                                String formattedDateTime =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(dateTime);
                                setState(() {
                                  _dateTimeController.text = formattedDateTime;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date and time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: textBold(
                    text: 'Choose a task classification',
                    color: ColorManager.white,
                    sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(18, 17, 28, 0.4),
                            blurRadius: 10.0,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(195, 197, 255, 1.0),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _importance,
                      items:
                          ['Important', 'normal', 'weak'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _importance = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        // labelStyle: const TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                        filled: true,
                        fillColor: const Color.fromRGBO(184, 187, 255, 0.6),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                      ),
                      dropdownColor: const Color.fromRGBO(202, 206, 255, 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                _isLogin
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: buttonApp(
                            text: 'Add task',
                            color: const Color.fromRGBO(89, 91, 112, 1.0),
                            sizeFont: 18,
                            height: 50,
                            width: 200,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                // addTask();
                              }


                              addTask();
                            }),
                      )
                    :   Center(child: loadingAppWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTask() async {
    try {

      setState(() {
        _isLogin = false;
      });
      String fCMToken = CacheHelper.getData(key: 'FCMToken') ?? '';
      String userID = CacheHelper.getData(key: 'UserID') ?? '';
      String fCMTokenAdmin = CacheHelper.getData(key: 'FCMTokenAdmin') ?? '';
      String userIDAdmin = CacheHelper.getData(key: 'UserIDAdmin') ?? '';
        String emailSecretary = CacheHelper.getData(key: 'emailSecretary');

      String name = CacheHelper.getData(key: 'nameSecretary') ?? '';

      // await _firestore.collection('tasks').add({
      //   'title': _titleController.text,
      //   'subtitle': _subtitleController.text,
      //   'dateTime': _dateTimeController.text,
      //   'importance': _importance,
      //   'name': name,
      //   'FCMToken': fCMToken,
      //   'UserID': userID,
      //   'FCMTokenAdmin': fCMTokenAdmin,
      //   'UserIDAdmin': userIDAdmin,
      //   'emailSecretary': emailSecretary,
      //   'note_admin': '',
      // });

      // await sendNotificationToAdmin();


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task has been added")),
      );

      // _titleController.clear();
      // _subtitleController.clear();
      // _dateTimeController.clear();

      setState(() {
        _isLogin = true;
      });
    } catch (e) {
      print('AAAAAAAASSSSSSSSSSSSSSS');
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create secretary account: $e")),
      );
      setState(() {
        _isLogin = true;
      });
    }
  }


  // Future<void> sendNotificationToAdmin() async {
  //   const String fcmToken = 'eX3CP5JWRBeqC9DsQ00WU_:APA91bHTfUhXaJKeISHLhbfq9grBrYLAcEa3w2mdq5xfYHHJH8XT_6TEbkJnJEnAK6FcAUaff_P34oKQ3trgsGBSfCwZg7_AYPvlUV9bORemgNDzZzaIh2TqGgYzonF8mGVDip8W8WE4';
  //
  //
  //   final serviceAccountJson = File('C:\\project_me\\secretarial_app\\secretarial-firebase-adminsdk-ckwmt-1ff646effb.json').readAsStringSync();
  //   // final serviceAccountJson = await rootBundle.loadString('assets/secretarial-firebase-adminsdk-ckwmt-1ff646effb.json');
  //
  //   final serviceAccountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
  //   const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  //   final authClient = await clientViaServiceAccount(serviceAccountCredentials, scopes);
  //   const fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/secretarial/messages:send';
  //   final message = {
  //     'message': {
  //       'token': fcmToken,
  //       'notification': {
  //         'title': 'New Task',
  //         'body': 'مرحبا',
  //       },
  //     },
  //   };
  //
  //   // Send the notification
  //   final response = await authClient.post(
  //     Uri.parse(fcmEndpoint),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(message),
  //   );
  //
  //
  //   if (response.statusCode == 200) {
  //     print('Notification sent successfully!');
  //   } else {
  //     print('Failed to send notification. Status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  //
  //   // Close the authenticated client
  //   authClient.close();
  // }






}
