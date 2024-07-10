import 'package:flutter/material.dart';
import 'package:secretarial_app/administration/home/screen/accepted_tasks.dart';
import 'package:secretarial_app/administration/home/screen/home_screen.dart';
import 'package:secretarial_app/administration/home/screen/rejected_tasks.dart';






class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;  // Start with the middle tab selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          AcceptedTasks(),
          HomeAdministrationScreen(),
          RejectedTasks()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Accepted tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),



          BottomNavigationBarItem(
            icon: Icon(Icons.remove_done),
            label: 'Rejected tasks',
          ),
        ],
      ),
    );
  }
}
