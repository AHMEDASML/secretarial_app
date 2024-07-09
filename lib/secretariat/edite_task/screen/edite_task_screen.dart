import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/components/appBar_app.dart';
import 'package:secretarial_app/global/components/button_app.dart';
import 'package:secretarial_app/global/components/text_app_bold.dart';
import 'package:secretarial_app/global/components/text_field_app.dart';
import 'package:secretarial_app/global/utils/color_app.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic> taskData;

  const EditTaskScreen({Key? key, required this.taskId, required this.taskData})
      : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _dateTimeController;
  late String _importance;
  bool _isSaving = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskData['title']);
    _subtitleController =
        TextEditingController(text: widget.taskData['subtitle']);
    _dateTimeController =
        TextEditingController(text: widget.taskData['dateTime']);
    _importance = widget.taskData['importance'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarApp(text: 'Edit Task'),
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
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the main title';
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
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subtitle';
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
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded corners
                        ),
                        suffixIconColor: const Color.fromRGBO(143, 148, 251, 1),
                        prefixIconColor: const Color.fromRGBO(143, 148, 251, 1),
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
                _isSaving
                    ? Center(child: loadingAppWidget())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: buttonApp(
                            text: 'Save task',
                            color: const Color.fromRGBO(89, 91, 112, 1.0),
                            sizeFont: 18,
                            height: 50,
                            width: 200,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                saveTask();
                              }
                            }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveTask() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Find the document ID where the 'id' field matches widget.taskId
      QuerySnapshot query = await _firestore
          .collection('tasks')
          .where('id', isEqualTo: widget.taskId)
          .get();

      if (query.docs.isNotEmpty) {
        String docId = query.docs.first.id;

        await _firestore.collection('tasks').doc(docId).update({
          'title': _titleController.text,
          'subtitle': _subtitleController.text,
          'dateTime': _dateTimeController.text,
          'importance': _importance,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task has been updated")),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update task: $e")),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}
