import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectemailauthdec1/Information/accounts.dart';
import 'package:projectemailauthdec1/Tutors/upload.dart';
import 'package:projectemailauthdec1/search%20notes.dart';

import '../authentication/login.dart';

class HomeB extends StatefulWidget {
  const HomeB({Key? key}) : super(key: key);

  @override
  State<HomeB> createState() => _HomeBState();
}

class _HomeBState extends State<HomeB> {
  String? user_name;
  String? user_class;
  String? user_email;
  String? user_loca;
  String? user_id;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
    );
  }

  Future<void> fetchUserEmail() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null)
      {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();

        if (userDoc.exists)
        {
          // Access the email and name fields
          final data = userDoc.data() as Map<String, dynamic>?;
          if(data != null)
          {
            setState(() {

              user_name = userDoc['name'];
              user_email = userDoc['email'];
              user_id = user.uid;
              // user_class = userDoc['classes'];
              // user_loca = userDoc['location'];
              // user_description = userDoc['description'];
              // user_subject = userDoc['subject'];
              // user_role = userDoc['role'];

            });
          }
          else
          {
            print('Document data is null');
          }
        }
        else
        {
          print('User document does not exist');
        }
      }
      else
      {
        print('No user is currently signed in');
      }
    }
    catch (e)
    {
      print('Error fetching user email: $e');
    }
  }

  downloadnotes() async{

  }

 uploadnotes() async{


  }


  Future<bool?> _showExitConfirmationDialog() async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit App"),
          content: const Text("Are you sure you want to exit the app?"),
          actions: <Widget> [
            TextButton(
              child : Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (exitApp == true) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop)
          return;

        final bool shouldPop = await _showExitConfirmationDialog() ?? false;

        if (context.mounted && shouldPop) {
          // Use exit() to completely close the app
          if (Platform.isAndroid || Platform.isIOS) {
            exit(0);
          } else {
            // For other platforms, use Navigator to pop
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF34B89B),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
            },
          ),
          title: Text(
            "Home",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Accounts(userId : user_id)),
                );
              },
            )
            ,
          ],
        ),
        body: user_name == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome!",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text('$user_name',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              const SizedBox(height: 20),
              Expanded( // Expands to fill the available space
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Centers content vertically
                    children: [
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed:()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Search()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            "Download Notes",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                          child : ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Upload()),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "Upload Notes",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: signout,
          child: Icon(Icons.exit_to_app),
          backgroundColor: Color(0xD59DE1D2),
        ),
      ),
    );
  }
}