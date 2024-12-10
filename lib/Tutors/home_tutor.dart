import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../login.dart'; // Import this to use exit()

class HomeB extends StatefulWidget {
  @override
  _HomeBState createState() => _HomeBState();
}

class _HomeBState extends State<HomeB> {

  String? user_email;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }


  Future<void> fetchUserEmail() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Access the email field
          setState(() {
            user_email = userDoc['email'];
          });
        } else {
          print('User document does not exist');
        }
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
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
  // Override the back button functionality to show a confirmation dialog
  Future<bool?> _AlertDialog() async {
    // Show a confirmation dialog when the back button is pressed
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Do you really want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                // Close the dialog and return false (stay in the app)
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Close the dialog and return true (exit the app)
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    // If exitApp is true, the app will exit
    return exitApp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop)
          return;

        final bool shouldPop = await _AlertDialog() ?? false;

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
            title: Text("Home Page"), // Title of the app bar
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle), // Account icon
                onPressed: () {
                  // Add functionality for account icon if needed
                  print("Account icon pressed");
                },
              ),
            ],
          ),
          body: Center(
            child: Text('Welcome to Home Page Tutor ${user_email}'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: signout,
            child: Icon(Icons.exit_to_app),
            backgroundColor: Color(0xD59DE1D2),
          )
      ),
    );
  }
}