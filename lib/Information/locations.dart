

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../authentication/login.dart';
import 'details.dart'; // Import the Details screen

class Locations extends StatefulWidget {
  final String email;
  final String role;

  const Locations({Key? key, required this.email, required this.role})
      : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class GridItem {
  final String title;
  final String imagePath;

  GridItem(this.title, this.imagePath);
}

class _LocationsState extends State<Locations> {
  final List<GridItem> items = [
    GridItem('Delhi NCR', 'assets/images/delhi.png'),
    GridItem('Mumbai', 'assets/images/mumbai.png'),
    GridItem('Bangalore', 'assets/images/bangalore.png'),
    GridItem('Banaras', 'assets/images/banaras.png'),
    GridItem('Hyderabad', 'assets/images/hyderabad.png'),
    GridItem('Lucknow', 'assets/images/lucknow.png'),
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to save the location to Firestore
  Future<void> saveLocation(String location) async {
    final user = _auth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'location': location,
        'isLocationFilled': true,
      });
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

  void onLocationTap(String locationName) {
    // Save the location to Firestore and navigate to the Details screen
    saveLocation(locationName).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Details(email: widget.email, role: widget.role, locationName: locationName),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .12,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35, bottom: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Choose your location:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF34B89B),
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.63,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * .65,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFAEAEAE),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const ShapeDecoration(
                color: Color(0xFF34B89B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      onLocationTap(item.title);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item.imagePath,
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Color(0xFFA18030),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
