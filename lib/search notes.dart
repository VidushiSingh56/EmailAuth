import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectemailauthdec1/view_notes_list.dart';
import '../../widgets/drop_down_with_text.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {


  String selectedBoard = 'CBSE';
  List<String> boardOptions = [
    'CBSE',
    'ICSE',
    'Andhra Pradesh Board',
    'Bihar Board',
    'Gujarat Board',
    'Karnataka Board',
    'Maharashtra Board',
    'Rajasthan Board',
    'Tamil Nadu Board',
    'West Bengal Board',
  ];
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

  void searchNotes() {
    String filename = '${selectedBoard}_${selectedClass}_${selectedSubject}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewNotesList(
          filename: filename, // Pass the filename to Download screen
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
          child: Text("Search Notes"),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            DropdownWithText(
              selectedValue: selectedBoard,
              options: boardOptions,
              labelText: 'Selected Board',
              onChanged: (newValue) {
                setState(() {
                  selectedBoard = newValue!;
                });
              },
            ),
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
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: ElevatedButton(
                onPressed: searchNotes,
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