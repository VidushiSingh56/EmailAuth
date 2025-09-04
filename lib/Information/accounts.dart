import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectemailauthdec1/widgets/stroke.dart';
import 'dart:io';

import '../authentication/login.dart';

class Accounts extends StatefulWidget {
  final String? userId; // Accept userId as a parameter

  const Accounts({Key? key, this.userId}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  String? userName;
  String? userEmail;
  String? userDes;
  String? userLocation;
  String? userSub;
  String? userClass;
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
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

              userName = userDoc['name'];
              userEmail = userDoc['email'];
              // user_id = user.uid;
              userClass = userDoc['classes'];
              userLocation = userDoc['location'];
              userDes= userDoc['description'];
              userSub= userDoc['subject'];
              userRole = userDoc['role'];

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


  signout() async {
    // Show a confirmation dialog
    bool? confirmExit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to sign out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed "No"
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed "Yes"
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );

    // If the user confirms, sign them out
    if (confirmExit == true) {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen and clear the navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        backgroundColor: Color(0xFF34B89B),
      ),
        body: userName == null
            ? const Center(
          child: Text(
            "No details! Sorry",
            style: TextStyle(fontSize: 18),
          ),
        )
            : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,  // 80% of the screen width
                    // height: MediaQuery.of(context).size.height * 0.8,

                    // color: Colors.grey,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min, // Centers content vertically

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                            ),
                            Text('$userName',
                            style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                          ],
                        ),
                        Strokes(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                            ),
                            Text('$userEmail',
                                style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                          ],
                        ),
                        Strokes(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profession',
                              style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                            ),
                            Text('$userRole',
                                style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                          ],
                        ),
                        Strokes(),
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subject',
                            style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                          ),
                          Text('$userSub',
                              style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                        ],
                      ),
                        Strokes(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City',
                              style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                            ),
                            Text('$userLocation',
                                style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                          ],
                        ),
                        Strokes(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Class',
                              style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                            ),
                            Text('$userClass',
                                style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                          ],
                        ),
                        Strokes(),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                            ),
                            Text('$userDes',
                                style: const TextStyle(color: Color(0xFF289E85),fontSize: 18 ))
                          ],
                        ),
                        SizedBox(height: 25,),
                        ElevatedButton(
                          onPressed: signout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,

                              minimumSize: Size(double.infinity, 50),
                            ),
                          child: const Text('Sign Out',
                          style: TextStyle(color: Colors.white,fontSize: 20),),
                        ),
                      ],
              
                    ),
                  ),
              
                ),
              ),
            ),

    );
  }
}
