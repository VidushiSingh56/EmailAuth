// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class Upload extends StatefulWidget {
//   @override
//   _UploadState createState() => _UploadState();
// }
//
// class _UploadState extends State<Upload> {
//   String? _fileName;
//   bool _isUploading = false;
//   File? _file;
//
//   // Function to pick file
//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       // Get the selected file
//       PlatformFile file = result.files.first;
//       setState(() {
//         _fileName = file.name;
//         _file = File(file.path!);
//       });
//     } else {
//       // User canceled the picker
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No file selected.")),
//       );
//     }
//   }
//
//   // Function to upload file to Firebase Storage
//   Future<void> uploadFile() async {
//     if (_file == null || _fileName == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a valid file first.")),
//       );
//       return;
//     }
//
//     // Check if the file exists
//     if (!_file!.existsSync()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("File does not exist.")),
//       );
//       return;
//     }
//
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       // Upload to Firebase Storage
//       Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$_fileName');
//       await storageRef.putFile(_file!);
//
//       // Get the download URL
//       String fileUrl = await storageRef.getDownloadURL();
//
//       // Save file URL and timestamp to Firestore
//       await FirebaseFirestore.instance.collection('files').add({
//         'fileUrl': fileUrl,
//         'fileName': _fileName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("File uploaded successfully.")),
//       );
//     } catch (e) {
//       // Handle errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error uploading file: $e")),
//       );
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("File Upload")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (_fileName != null)
//               Text("Selected file: $_fileName", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickFile,
//               child: Text("Pick File"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isUploading ? null : uploadFile,
//               child: _isUploading
//                   ? CircularProgressIndicator()
//                   : Text("Upload File"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectemailauthdec1/Information/accounts.dart';
import 'package:projectemailauthdec1/Information/details.dart';
import 'package:projectemailauthdec1/authentication/login.dart';
import '../../widgets/drop_down_with_text.dart';
// import '../Profile.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  _Upload createState() => _Upload();
}

class _Upload extends State<Upload> {


  String? user_id;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String?> uploadPdf(File file, String fileName) async {
    final refrence = FirebaseStorage.instance
        .ref()
        .child(selectedBoard)
        .child(selectedClass)
        .child(selectedSubject)
        .child('pdfs/$fileName');

    await refrence.putFile(file).whenComplete(() {});
    final downloadLink = refrence.getDownloadURL();

    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      String filename =
          selectedBoard + "_"+selectedClass+ "_" + selectedSubject;
      String name=pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);

      final downloadlink = await uploadPdf(file, filename);

      await _firebaseFirestore.collection("pdfs").add({
        "filename": filename,
        "Name":name,
        "url": downloadlink,
        'timestamp': FieldValue.serverTimestamp(),

      });

      Fluttertoast.showToast(
        msg: "PDF uploaded successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  Future<void> fetchUserEmail() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null)
      {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();

        if (userDoc.exists)
        {
          // Access the email and name fields
          final data = userDoc.data() as Map<String, dynamic>?;
          if(data != null)
          {
            setState(() {


              user_id = user.uid;
              // user_class = userDoc['classes'];
              // user_loca = userDoc['location'];
              // user_description = userDoc['description'];
              // user_subject = userDoc['subject'];
              // user_role = userDoc['role'];

            });
          }
          else
          {
            print('Document data is null');
          }
        }
        else
        {
          print('User document does not exist');
        }
      }
      else
      {
        print('No user is currently signed in');
      }
    }
    catch (e)
    {
      print('Error fetching user email: $e');
    }
  }

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
  // String selectedChapter = '1';
  // List<String> chapterOptions = [
  //   '1',
  //   '2',
  //   '3',
  //   '4',
  //   '5',
  //   '6',
  //   '7',
  //   '8',
  //   '9',
  //   '10',
  //   '11',
  //   '12',
  //   '13',
  //   '14',
  //   '15'
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34B89B),
        title: const Center(
          child: Text("Upload Notes"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Accounts(userId : user_id)),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
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
              labelText: 'Selected Subjects',
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue!;
                });
              },
            ),
            // DropdownWithText(
            //   selectedValue: selectedChapter,
            //   options: chapterOptions,
            //   labelText: 'Selected Chapter',
            //   onChanged: (newValue) {
            //     setState(() {
            //       selectedChapter = newValue!;
            //     });
            //   },
            // ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: ElevatedButton(
                onPressed: pickFile,
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
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text(
                      "Upload",
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

