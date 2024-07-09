// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:animate_do/animate_do.dart';
import 'package:secretarial_app/administration/home/screen/home_screen.dart';
import 'package:secretarial_app/administration/home/screen/main_screen.dart';
import 'package:secretarial_app/auth/reg/screen/registration_screen.dart';
import 'package:secretarial_app/global/common/functions_app.dart';
import 'package:secretarial_app/global/common/loading_app.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/utils/key_shared.dart';
import 'package:secretarial_app/secretariat/home/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLogin = true;

  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1)))),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email or Phone number",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),


                    _isLogin  ? FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: GestureDetector(
                          onTap: () {
                            signInFun();
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )) :   loadingAppWidget(),

                    const SizedBox(
                      height: 70,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 2000),
                        child: GestureDetector(
                          onTap: () {
                            navigateTo(context, const RegistrationScreen());
                          },
                          child: const Text(
                            "registration ",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void signInFun() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      print("Email and password cannot be empty");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Email and password cannot be empty"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      IsChanges(false);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );


      print('ASDASDASDASDASDASDWQEQWE');
      print(userCredential);
      DocumentSnapshot userData = await _firestore.collection('users').doc(userCredential.user?.uid).get();

      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      String? userRole = data['role'];


      if (userRole == 'secretary') {
        print("User is a secretary, returning false.");

        String userId = userCredential.user?.uid ?? '';
        DocumentSnapshot secretaryData = await _firestore.collection('users').doc(userId).get();
        Map<String, dynamic> secretaryInfo = secretaryData.data() as Map<String, dynamic>;
        // print("Secretary Information: $secretaryInfo");
        print("Secretary Information");
        print(secretaryInfo['email']);
        print(secretaryInfo['name']);
        CacheHelper.saveData(key: 'FCMTokenAdmin', value: secretaryInfo['FCMTokenAdmin']);
        CacheHelper.saveData(key: 'UserIDAdmin', value: secretaryInfo['UserIDAdmin']);
        CacheHelper.saveData(key: 'nameSecretary', value: secretaryInfo['name']);
        CacheHelper.saveData(key: 'emailSecretary', value: secretaryInfo['email']);



        navigateTo(context, const HomeScreenSecretariat());
        IsChanges(true);

      } else {


        String? fcmToken;
        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          fcmToken = await FirebaseMessaging.instance.getToken();
          CacheHelper.saveData(key: 'FCMTokenAdmin', value: fcmToken);
        }

        String userId = userCredential.user?.uid ?? '';
        String name = data['name'] ?? "";

        CacheHelper.saveData(key: 'UserIDAdmin', value: userId);
        CacheHelper.saveData(key: 'nameAdmin', value: name);

        navigateTo(context, const MainScreen());
        IsChanges(true);

      }

      print("Signed in: ${userCredential.user?.email}");

    } catch (e) {
      print("Failed to sign in: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign-In Error"),
            content: const Text('There is an error in the information'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      IsChanges(true);
    }
  }

  IsChanges(bool b) {
    setState(() {
      _isLogin = b;
    });
  }
}
