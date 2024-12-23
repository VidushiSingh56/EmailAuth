import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectemailauthdec1/Students/home_student.dart';

import '../Tutors/home_tutor.dart';

class Details extends StatefulWidget {
  final String email;
  final String locationName;
  final String role;

  const Details({Key? key, required this.email, required this.role,required this.locationName})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late TextEditingController locationController;
  final TextEditingController classesController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController(text: widget.locationName);
  }

  @override
  void dispose() {
    locationController.dispose();
    classesController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> submitDetails() async {
    if (locationController.text.isEmpty ||
        nameController.text.isEmpty ||
        classesController.text.isEmpty ||
        subjectController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the details')),
      );
      return;
    }

    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Reference to the user's document in Firestore
        DocumentReference userDetails = FirebaseFirestore.instance
            .collection('user')
            .doc(uid);

        // Save details in Firestore (overwrite or create if not exists)
        await userDetails.set({
          'email': widget.email,
          'role': widget.role,
          'location': locationController.text,
          'name': nameController.text,
          'classes': classesController.text,
          'subject': subjectController.text,
          'description': descriptionController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details submitted successfully!')),
        );

        // Navigate to the appropriate screen based on the role
        if (widget.role == 'student') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeA()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeB()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated. Please log in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit details. Please try again.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email (read-only)
                TextField(
                  controller: TextEditingController(text: widget.email),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false, // Make the field uneditable
                ),
                SizedBox(height: 20),
                TextField(
                  controller: TextEditingController(text: widget.role),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false, // Make the field uneditable
                ),
                SizedBox(height: 20),

                // Location (editable)
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Classes
                TextField(
                  controller: classesController,
                  decoration: InputDecoration(
                    labelText: 'Enter Class',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Subject
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Enter Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Description
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  onPressed: submitDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
