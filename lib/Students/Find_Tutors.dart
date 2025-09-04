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

  // List<DocumentSnapshot> tutorsList = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   fetchTutors();
  // }
  //
  // void fetchTutors() async {
  //   // Replace this with your actual Firebase query or data fetching logic
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tutors').get();
  //   setState(() {
  //     tutorsList = snapshot.docs;
  //   });
  // }


  void searchTutors() async {
    // Fetch all tutors with the role 'Tutor'
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user') // Replace 'user' with your actual collection name
        .where('role', isEqualTo: 'Tutor')
        .get();

    final List<DocumentSnapshot> allTutors = querySnapshot.docs;

    // Filter tutors manually based on the selected criteria
    final List<DocumentSnapshot> matchingTutors = allTutors.where((tutor) {
      final subjectMatch = tutor['subject'] == selectedSubject;
      final cityMatch = tutor['location'] == selectedCity;
      final classMatch = tutor['classes'] == selectedClass;

      // Add more conditions if needed
      return cityMatch;
    }).toList();

    // Navigate to ViewTutorList page with the filtered tutors
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewTutorList(
          tutors: matchingTutors, // Pass the list of tutors to the next page
          selectedSubject: selectedSubject,  // the selected subject
          selectedCity: selectedCity,  // the selected city
          selectedClass: selectedClass,
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
