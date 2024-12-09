import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectemailauthdec1/login.dart';
import 'details.dart'; // Import the Details screen

class ScreenA extends StatefulWidget {
  const ScreenA({super.key});

  @override
  State<ScreenA> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenA> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
    );
  }

  void onLocationTap(String locationName) {
    // Navigate to the Details screen with the selected location
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(locationName: locationName), // Pass location name to Details screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Choose your location",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        toolbarHeight: 70.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 70),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    children: [
                      locationItem("Delhi NCR", Icons.location_city),
                      locationItem("Mumbai", Icons.location_city),
                      locationItem("Bangalore", Icons.location_city),
                      locationItem("Banaras", Icons.location_city),
                      locationItem("Hyderabad", Icons.location_city),
                      locationItem("Lucknow", Icons.location_city),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signout,
        child: Icon(Icons.exit_to_app),
        backgroundColor: Color(0xD59DE1D2),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget locationItem(String locationName, IconData icon) {
    return GestureDetector(
      onTap: () {
        onLocationTap(locationName);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2, color: Colors.grey)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF34B89B)),
            SizedBox(height: 10),
            Text(
              locationName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF34B89B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
