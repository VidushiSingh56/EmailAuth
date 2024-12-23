import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package
import 'package:projectemailauthdec1/Information/role.dart';
import 'package:projectemailauthdec1/authentication/login.dart';
import 'package:projectemailauthdec1/Information/locations.dart';
import 'package:projectemailauthdec1/Information/details.dart'; // Import Details screen
import 'package:projectemailauthdec1/Tutors/home_tutor.dart';
import 'package:projectemailauthdec1/Students/home_student.dart';

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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Extract role and location information
        String role = userDoc['role'];
        bool isLocationFilled = userDoc['location'] != null;
        String email = user.email ?? '';

        return {
          'role': role,
          'isLocationFilled': isLocationFilled,
          'locationName': userDoc['location'], // Optional: Pass location name if needed
          'email': email,
        };
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
              future: getUserDetails(), // Fetch user details directly from Firestore
              builder: (context, detailsSnapshot) {
                if (detailsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (detailsSnapshot.hasData) {
                  var details = detailsSnapshot.data!;
                  if (details['isLocationFilled']) {
                    // Navigate to the respective Home screen based on role
                    if (details['role'] == 'tutor') {
                      return HomeB(); // Home screen for tutors
                    } else if (details['role'] == 'student') {
                      return HomeA(); // Home screen for students
                    }
                  } else {
                    // If location is not filled, navigate to Locations screen
                    return Locations(
                      email: details['email'],
                      role : details['role']// Pass email as parameter
                    );
                  }
                }
                // Default to Choose screen if no data is found
                return Choose();
              },
            );
          }

          // Return Login screen if user is not authenticated
          return Login();
        },
      ),
    );
  }
}
