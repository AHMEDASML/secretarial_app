import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/components/no_data_widget.dart';

class AllSecretarial extends StatefulWidget {
  const AllSecretarial({Key? key}) : super(key: key);

  @override
  State<AllSecretarial> createState() => _AllSecretarialState();
}

class _AllSecretarialState extends State<AllSecretarial> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Secretarial',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(123, 97, 255, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(

        stream: _firestore.collection('users').where('role', isEqualTo: 'secretary').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return   Center(child: loadingAppWidget());
            default:

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return  const NoDataWidget();
              }


              return ListView(
                padding: const EdgeInsets.all(10),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromRGBO(143, 148, 251, 0.6),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        data['name'] ?? 'No Name Provided',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(123, 97, 255, 1),
                        ),
                      ),
                      subtitle: Text(
                        data['email'] ?? 'No Email Provided',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      tileColor: const Color.fromRGBO(143, 148, 251, 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Color.fromRGBO(143, 148, 251, 1), width: 1),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

