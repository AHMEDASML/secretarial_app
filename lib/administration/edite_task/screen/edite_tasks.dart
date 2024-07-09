import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/components/appBar_app.dart';
import 'package:secretarial_app/global/utils/color_app.dart';

class EditeTasks extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic> taskData;

  const EditeTasks({
    Key? key,
    required this.taskId,
    required this.taskData,
  }) : super(key: key);

  @override
  State<EditeTasks> createState() => _EditeTasksState();
}

class _EditeTasksState extends State<EditeTasks> {
  final TextEditingController _noteController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.taskData['note_admin'] ?? '';
  }

  void _saveNote() async {
    setState(() {
      isLoading = true; // تعيين حالة التحميل إلى true
    });

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'note_admin': _noteController.text});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update note: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarApp(
          text: "Add a comment",
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


        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 90,),

                const Text('A note can be added and shown to the secretary',style: TextStyle(
                  color: Color.fromRGBO(238, 243, 255, 1.0),fontWeight: FontWeight.w500,fontSize: 16
                ),),



                const SizedBox(height: 10,),



                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: "Manager's Note",
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.all(10.0),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ?   loadingAppWidget()
                    : ElevatedButton(
                  onPressed: _saveNote,
                  child: const Text('Save Note'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
