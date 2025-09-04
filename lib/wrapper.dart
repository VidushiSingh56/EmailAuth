import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectemailauthdec1/Information/role.dart';
import 'package:projectemailauthdec1/authentication/login.dart';
import 'package:projectemailauthdec1/Information/locations.dart';
import 'package:projectemailauthdec1/Information/details.dart';
import 'package:projectemailauthdec1/Tutors/home_tutor.dart';
import 'package:projectemailauthdec1/Students/home_student.dart';
import 'package:projectemailauthdec1/splashscreen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // Function to get the user's details from Firestore
  Future<Map<String, dynamic>?> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            String? role = data['role'];
            String? name = data['name'];
            String? location = data['location'];
            bool isLocationFilled = location != null && location.isNotEmpty;
            String email = user.email ?? '';

            // Check if critical fields are missing
            if (role == null || name == null || location == null) {
              // Treat this case as invalid user data
              return null;
            }

            return {
              'role': role,
              'name': name,
              'isLocationFilled': isLocationFilled,
              'location': location,
              'email': email,
            };
          }
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if user is authenticated
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return FutureBuilder<Map<String, dynamic>?>(
              future: getUserDetails(),
              builder: (context, detailsSnapshot) {
                if (detailsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (detailsSnapshot.hasData) {
                  var details = detailsSnapshot.data!;

                  if (details['name'] == null || details['name'].isEmpty) {
                    return Details(
                      email: details['email'],
                      role: details['role'],
                      locationName: details['location'],
                    );
                  } else if (details['isLocationFilled'] == true) {
                    if (details['role'] == 'tutor' || details['role'] == 'Tutor') {
                      return HomeB();
                    } else if (details['role'] == 'student' || details['role'] == 'Student') {
                      return HomeA();
                    }
                  } else {
                    return Locations(
                      email: details['email'],
                      role: details['role'],
                    );
                  }
                }

                // Redirect to Login if user data is null or invalid
                return Login();
              },
            );
          }

          // Redirect to Login if user is not authenticated
          return Login();
        },
      ),
    );
  }
}
