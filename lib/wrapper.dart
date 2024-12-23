// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package
// import 'package:projectemailauthdec1/Information/role.dart';
// import 'package:projectemailauthdec1/authentication/login.dart';
// import 'package:projectemailauthdec1/Information/locations.dart';
// import 'package:projectemailauthdec1/Information/details.dart'; // Import Details screen
// import 'package:projectemailauthdec1/Tutors/home_tutor.dart';
// import 'package:projectemailauthdec1/Students/home_student.dart';
//
// class Wrapper extends StatefulWidget {
//   const Wrapper({super.key});
//
//   @override
//   State<Wrapper> createState() => _WrapperState();
// }
//
// class _WrapperState extends State<Wrapper> {
//   // Function to get the user's details from Firestore
//   Future<Map<String, dynamic>?> getUserDetails() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(user.uid)
//           .get();
//
//       if (userDoc.exists) {
//         // Extract role and location information
//         String role = userDoc['role'];
//         bool isLocationFilled = userDoc['location'] != null;
//
//         String email = user.email ?? '';
//
//         return {
//           'role': role,
//           'isLocationFilled': isLocationFilled,
//           'locationName': userDoc['location'], // Optional: Pass location name if needed
//           'email': email,
//         };
//       }
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           // Check if user is authenticated
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasData) {
//             return FutureBuilder<Map<String, dynamic>?>(
//               future: getUserDetails(), // Fetch user details directly from Firestore
//               builder: (context, detailsSnapshot) {
//                 if (detailsSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (detailsSnapshot.hasData) {
//                   var details = detailsSnapshot.data!;
//                   if (details['isLocationFilled']) {
//                     // Navigate to the respective Home screen based on role
//                     if (details['role'] == 'tutor')
//                     {
//                       return HomeB(); // Home screen for tutors
//                     } else if (details['role'] == 'student') {
//                       return HomeA(); // Home screen for students
//                     }
//                   } else {
//                     // If location is not filled, navigate to Locations screen
//                     return Locations(
//                       email: details['email'],
//                       role : details['role']// Pass email as parameter
//                     );
//                   }
//                 }
//                 // Default to Choose screen if no data is found
//                 return Choose();
//               },
//             );
//           }
//
//           // Return Login screen if user is not authenticated
//           return Login();
//         },
//       ),
//     );
//   }
// }



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
          // Safely access fields using data() and null checks
          final data = userDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            String? role = data['role']; // Retrieve role directly
            String? name = data.containsKey('name') ? data['name'] : null; // Check existence
            String? location = data.containsKey('location') ? data['location'] : null;
            bool isLocationFilled = location != null && location.isNotEmpty;
            String email = user.email ?? '';

            return {
              'role': role,
              'name': name,
              'isLocationFilled': isLocationFilled,
              'location': location,
              'email': email,
            };
          }
        }

        // Log if document does not exist
        print('User document does not exist.');
      } catch (e) {
        // Handle any exceptions during the fetch
        print('Error fetching user details: $e');
      }
    }

    // Return null if user is not authenticated or data could not be fetched
    return null;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if user is authenticated
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData)
          {
            return FutureBuilder<Map<String, dynamic>?>(
              future: getUserDetails(),
              builder: (context, detailsSnapshot)
              {
                if (detailsSnapshot.connectionState == ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator());
                }

                if (detailsSnapshot.hasData)
                {
                  var details = detailsSnapshot.data!;
                  print({details['name']});
                  // Check if the name field exists
                  if (details['name'] == null || details['name'].isEmpty)
                  {
                    // Navigate to the Details screen if the name does not exist

                    return Details(
                      email: details['email'],
                      role: details['role'],
                      locationName: details['location'],
                    );
                  }

                  // Check if the location is filled
                  else if (details['isLocationFilled'] == true)
                  {
                    // Navigate to the respective Home screen based on role
                    if (details['role'] == 'tutor' || details['role'] == 'Tutor') {
                      return HomeB();
                    } else if (details['role'] == 'student' || details['role'] == 'Student') {
                      return HomeA();
                    }
                  }
                  else {
                    // If location is not filled, navigate to Locations screen
                    return Locations(
                      email: details['email'],
                      role: details['role'],
                    );
                  }
                }
                // Default to Choose screen if no user data is found
                return SplashScreen();
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
