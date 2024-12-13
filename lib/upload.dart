import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String? _fileName;
  bool _isUploading = false;
  File? _file;

  // Function to pick file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the selected file
      PlatformFile file = result.files.first;
      setState(() {
        _fileName = file.name;
        _file = File(file.path!);
      });
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected.")),
      );
    }
  }

  // Function to upload file to Firebase Storage
  Future<void> uploadFile() async {
    if (_file == null || _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a valid file first.")),
      );
      return;
    }

    // Check if the file exists
    if (!_file!.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File does not exist.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$_fileName');
      await storageRef.putFile(_file!);

      // Get the download URL
      String fileUrl = await storageRef.getDownloadURL();

      // Save file URL and timestamp to Firestore
      await FirebaseFirestore.instance.collection('files').add({
        'fileUrl': fileUrl,
        'fileName': _fileName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File uploaded successfully.")),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Upload")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_fileName != null)
              Text("Selected file: $_fileName", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickFile,
              child: Text("Pick File"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : uploadFile,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text("Upload File"),
            ),
          ],
        ),
      ),
    );
  }
}
