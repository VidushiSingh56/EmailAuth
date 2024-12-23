import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_tutor_list.dart';
import '../../widgets/drop_down_with_text.dart';

class FindHomeTutors extends StatefulWidget {
  const FindHomeTutors({super.key});

  @override
  _FindHomeTutorsState createState() => _FindHomeTutorsState();
}

class _FindHomeTutorsState extends State<FindHomeTutors> {
  // String selectedBoard = 'CBSE';
  // List<String> boardOptions = [
  //   'CBSE',
  //   'ICSE',
  //   'Andhra Pradesh Board',
  //   'Bihar Board',
  //   'Gujarat Board',
  //   'Karnataka Board',
  //   'Maharashtra Board',
  //   'Rajasthan Board',
  //   'Tamil Nadu Board',
  //   'West Bengal Board',
  // ];
  String selectedClass = '1';
  List<String> classOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  String selectedSubject = 'Mathematics';
  List<String> subjectOptions = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
    'Economics',
    'Computer Science',
    'Accountancy',
    'Business Studies',
    'Others'
  ];
  String selectedCity = 'Bangalore';
  List<String> cityOptions = [
    'Delhi NCR',
    'Bangalore',
    'Mumbai',
    'Lucknow',
    'Banaras',
    'Hyderabad'
  ];

  void searchTutors() async {
    // Fetch tutors matching the criteria from Firestore
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user') // Replace 'users' with your actual collection name
        .where('role', isEqualTo: 'Tutor') // Ensure only tutors are retrieved
        .where('subject', isEqualTo: selectedSubject)
        .where('location', isEqualTo: selectedCity)
        // .where('board', isEqualTo: selectedBoard)
        .where('classes', isEqualTo: selectedClass) // Assume 'class' is a list
        .get();

    final List<DocumentSnapshot> tutors = querySnapshot.docs;

    // Navigate to ViewTutorList page with the fetched tutors
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewTutorList(
          tutors: tutors, // Pass the list of tutors to the next page
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34B89B),
        title: const Center(
          child: Text("Search Tutors"),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            // DropdownWithText(
            //   selectedValue: selectedBoard,
            //   options: boardOptions,
            //   labelText: 'Selected Board',
            //   onChanged: (newValue) {
            //     setState(() {
            //       selectedBoard = newValue!;
            //     });
            //   },
            // ),
            DropdownWithText(
              selectedValue: selectedClass,
              options: classOptions,
              labelText: 'Selected Class',
              onChanged: (newValue) {
                setState(() {
                  selectedClass = newValue!;
                });
              },
            ),
            DropdownWithText(
              selectedValue: selectedSubject,
              options: subjectOptions,
              labelText: 'Selected Subject',
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue!;
                });
              },
            ),
            DropdownWithText(
              selectedValue: selectedCity,
              options: cityOptions,
              labelText: 'Selected City',
              onChanged: (newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: ElevatedButton(
                onPressed: searchTutors,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
