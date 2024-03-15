
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tut/screens/email_auth/login_screen.dart';
import 'package:firebase_tut/screens/home_screen.dart';
import 'package:firebase_tut/services/notification_services.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Wait for widgets to be initialized
  await Firebase.initializeApp(); // Initialize Firebase

  await NotificationService.initalize();

  /* To fetch the data from the firestore.
    QuerySnapshot to get the whole collection
    DocumentSnapshot to get the particular document from the collection
   */
  // DocumentSnapshot snapshot =
      // await FirebaseFirestore.instance.collection("users").doc("hGLIzLAfaSLMg2w4d44H").get();

  // // to fetch all the collection from firestore
  // // for(var doc in snapshot.docs){
  // //   print(doc.data().toString());
  // // }

  // log(snapshot.data().toString());
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Map<String, dynamic> newUserData = {
  //   "name": "slantcode",
  //   "email": "slantcode@gmail.com"
  // };
  
  /* 
      .add() : To add a new document with auto generated id
      .doc('id-her').set(userData) : To add a new document with id that we mention here
      .doc('id').update({map data here that needs to update}) :
          Update the mention field in map where id i.e. mention in doc('id')
  */
  // await _firestore.collection("users").doc('your-id-here').set(newUserData);
  // log("New user saved");

  // await _firestore.collection("users").doc("your-id-here").delete();
  // log("Deleted");

  runApp(MyApp()); // Run your app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
