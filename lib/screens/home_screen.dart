import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_tut/screens/email_auth/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';


// import 'package:firebaseseries/screens/email_auth/login_screen.dart';
// import 'package:firebaseseries/screens/email_auth/signup_screen.dart';
// import 'package:firebaseseries/screens/phone_auth/sign_in_with_phone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilepic;
  // TextEditingController ageController = TextEditingController();
  // File? profilepic;

  // void logOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.popUntil(context, (route) => route.isFirst);
  //   Navigator.pushReplacement(context, CupertinoPageRoute(
  //     builder: (context) => SignInWithPhone()
  //   ));
  // }

  // void saveUser() async {
  //   String name = nameController.text.trim();
  //   String email = emailController.text.trim();
  //   String ageString = ageController.text.trim();

  //   int age = int.parse(ageString);

  //   nameController.clear();
  //   emailController.clear();
  //   ageController.clear();

  //   if(name != "" && email != "" && profilepic != null) {

  //     UploadTask uploadTask = FirebaseStorage.instance.ref().child("profilepictures").child(Uuid().v1()).putFile(profilepic!);

  //     StreamSubscription taskSubscription = uploadTask.snapshotEvents.listen((snapshot) {
  //       double percentage = snapshot.bytesTransferred/snapshot.totalBytes * 100;
  //       log(percentage.toString());
  //     });

  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  //     taskSubscription.cancel();

  //     Map<String, dynamic> userData = {
  //       "name": name,
  //       "email": email,
  //       "age": age,
  //       "profilepic": downloadUrl,
  //       "samplearray": [name, email, age]
  //     };
  //     FirebaseFirestore.instance.collection("users").add(userData);
  //     log("User created!");
  //   }
  //   else{
  //     log("Please fill all the fields!");
  //   }

  //   setState(() {
  //     profilepic = null;
  //   });
  // }

  // void getInitialMessage() async {
  //   RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

  //   if(message != null) {
  //     if(message.data["page"] == "email") {
  //       Navigator.push(context, CupertinoPageRoute(
  //         builder: (context) => SignUpScreen()
  //       ));
  //     }
  //     else if(message.data["page"] == "phone") {
  //       Navigator.push(context, CupertinoPageRoute(
  //         builder: (context) => SignInWithPhone()
  //       ));
  //     }
  //     else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("Invalid Page!"),
  //         duration: Duration(seconds: 5),
  //         backgroundColor: Colors.red,
  //       ));
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   getInitialMessage();

  //   FirebaseMessaging.onMessage.listen((message) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(message.data["myname"].toString()),
  //       duration: Duration(seconds: 10),
  //       backgroundColor: Colors.green,
  //     ));
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("App was opened by a notification"),
  //       duration: Duration(seconds: 10),
  //       backgroundColor: Colors.green,
  //     ));
  //   });
  // }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => LoginScreen()));
  }

  void saveUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageController.text.trim();
    int age = int.parse(ageString);

    nameController.clear();
    emailController.clear();
    ageController.clear();

    if (name != "" && email != "" && age != "" && profilepic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("profilepictures")
          .child(Uuid().v1())
          .putFile(profilepic!);

      StreamSubscription taskSubscription = uploadTask.snapshotEvents.listen((snapshot) {
        double percentage = snapshot.bytesTransferred/snapshot.totalBytes * 100;
        log(percentage.toString());
      });


      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      taskSubscription.cancel(); 

      FirebaseFirestore.instance.collection("users").add({
        "name": name,
        "email": email,
        "age": age,
        "profilepic": downloadUrl
      });

      log("user created");
    } else {
      log("Please fill all the fields");
    }

    setState(() {
      profilepic = null;
    });
  }

  void delete(String id) {
    log(id.runtimeType.toString());
    FirebaseFirestore.instance.collection("users").doc(id).delete();
    log("Deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            IconButton(
              onPressed: () {
                logOut();
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CupertinoButton(
                onPressed: () async {
                  XFile? selectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });
                    log("Image selected");
                  } else {
                    log("No image selected");
                  }
                },
                padding: EdgeInsets.all(0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      (profilepic != null) ? FileImage(profilepic!) : null,
                  backgroundColor: Colors.grey,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: "age"),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    saveUser();
                  },
                  child: Text("Save")),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("age", isGreaterThanOrEqualTo: 20)
                      .orderBy("age")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> userMap =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                String id = snapshot.data!.docs[index].id;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userMap['profilepic']),
                                  ),
                                  title: Text(userMap['name'] +
                                      " (${userMap['age'].toString()})"),
                                  subtitle: Text(userMap['email']),
                                  trailing: IconButton(
                                    onPressed: () {
                                      delete(id);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Text("No data");
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        )));
  }
}
