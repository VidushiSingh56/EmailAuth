import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String locationName;

  const Details({Key? key, required this.locationName}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // Text controllers for the form
  final TextEditingController emailController = TextEditingController();
  late TextEditingController locationController; // Controller for the location name
  final TextEditingController classesController = TextEditingController();
  final TextEditingController subjectController =  TextEditingController();
  final TextEditingController descriptionController =  TextEditingController();
  final TextEditingController nameController =  TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize location controller with the passed location name
    locationController = TextEditingController(text: widget.locationName);
  }

  @override
  void dispose() {
    emailController.dispose();
    locationController.dispose(); // Dispose the location controller
    classesController.dispose();
    super.dispose();
  }

  // Function to submit data to Firestore
  Future<void> submitDetails() async {
    // Create a map with the data to submit
    final Map<String, String> details = {
      'location': locationController.text,
      'email': emailController.text,
      'classes': classesController.text,
    };

    try {
      // Reference to Firestore collection where the data will be stored
      CollectionReference locations = FirebaseFirestore.instance.collection('locations');

      // Add the data to Firestore
      await locations.add(details);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Details submitted successfully!'),
      ));

      // Optionally, navigate to another screen after successful submission
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SomeOtherScreen()));

    } catch (e) {
      // Handle any errors that occur during the submission
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit details. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null, // No back button
        backgroundColor: Color(0xFF34B89B), // Background color
        toolbarHeight: 90.0, // Increase AppBar height
        title: Text(
          "Details",
          style: TextStyle(
            fontSize: 25, // Font size
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location name field pre-filled and editable
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Location Name',
                // labelText: 'Location Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Email input field with its controller
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter email',
                // labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Email input field with its controller
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter email',
                // labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Classes input field with its controller
            TextField(
              controller: classesController,
              decoration: InputDecoration(
                hintText: 'Enter classes',
                // labelText: 'Classes',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Email input field with its controller
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: 'Enter email',
                // labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Email input field with its controller
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
                // Optional: Add content padding to adjust the height
                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Adjust vertical padding
              ),
              minLines: 3, // Minimum number of lines when the field is empty
              maxLines: 5, // Maximum number of lines the field can grow to
            ),

            SizedBox(height: 20),

            // Display location name dynamically
            Text(
              "More details about ${widget.locationName} will be displayed here.",
              style: TextStyle(fontSize: 18),
            ),

            // Submit button to store data in the database
            ElevatedButton(
              onPressed: () {
                submitDetails();  // Call the function to submit the data
              },
              child: Text('Submit Details'),
            ),
          ],
        ),
      ),
    );
  }
}
