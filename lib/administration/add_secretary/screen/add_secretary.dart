import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/components/appBar_app.dart';
import 'package:secretarial_app/global/components/button_app.dart';
import 'package:secretarial_app/global/components/text_app_bold.dart';
import 'package:secretarial_app/global/components/text_field_app.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/utils/color_app.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
class AddSecretary extends StatefulWidget {
  const AddSecretary({Key? key}) : super(key: key);

  @override
  State<AddSecretary> createState() => _AddSecretaryState();
}

class _AddSecretaryState extends State<AddSecretary> {

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin= true;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: appBarApp(text: 'Add a secretary'),
      body: Container(
        decoration: const BoxDecoration(

            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                  Color.fromRGBO(184, 187, 255, 0.6),
                ]
            )

        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child: textBold(text: "Secretary's name",color: ColorManager.white,sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),


                TextFieldApp(
                  controller: _nameController,
                  hintText: "Secretary's name",
                  prefixIcon: const Icon(Icons.supervised_user_circle),
                  suffixIcon: Container(),
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the secretary's name";
                    }
                    return null;
                  },
                ),




                const SizedBox(height: 16.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child: textBold(text: "Secretary email",color: ColorManager.white,sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFieldApp(
                  controller: _emailController,
                  hintText: "Secretary email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: Container(),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the secretary's email";
                    }
                    return null;
                  },
                ),





                const SizedBox(height: 16.0),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child: textBold(text: 'password',color: ColorManager.white,sizeFont: 18,
                    textAlign: TextAlign.start,
                  ),
                ),

                TextFieldApp(

                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: Container(),
                  textInputType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),



                const SizedBox(height: 32.0),

                _isLogin
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: buttonApp(
                    text: 'Add a secretary',
                    color: const Color.fromRGBO(89, 91, 112, 1.0),
                    sizeFont: 18,
                    height: 50,
                    width: 200,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLogin = false;
                        });

                        createSecretaryAccount();
                        // _createSecretaryAccount();
                      }
                    },
                  ),
                )
                    :   Center(child: loadingAppWidget()),



              ],
            ),
          ),
        ),
      ),
    );
  }




  void createSecretaryAccount() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

       String fCMToken = CacheHelper.getData(key: 'FCMTokenAdmin');
       String userID = CacheHelper.getData(key: 'UserIDAdmin');
       String nameAdmin = CacheHelper.getData(key: 'nameAdmin');

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': 'secretary',
        'FCMTokenAdmin': fCMToken,
        'UserIDAdmin': userID,
        'nameAdmin': nameAdmin,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The secretary's account has been added")),
      );

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();


      setState(() {
        _isLogin = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create secretary account: $e")),
      );
      setState(() {
        _isLogin = true;
      });
    }
  }
}
