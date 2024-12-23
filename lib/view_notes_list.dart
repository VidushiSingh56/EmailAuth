import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectemailauthdec1/pdf_viewer.dart';

class ViewNotesList extends StatefulWidget {
  final String filename;

  const ViewNotesList({Key? key, required this.filename}) : super(key: key);

  @override
  _ViewNotesListState createState() => _ViewNotesListState();
}

class _ViewNotesListState extends State<ViewNotesList> {
  late Stream<QuerySnapshot> _searchResultsStream;
  PDFDocument? _document;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchResultsStream = FirebaseFirestore.instance
        .collection("pdf")
        .where("originalName", isEqualTo: widget.filename)
        .snapshots();
  }

  // Updated permission request to handle both storage permissions
  Future<bool> _requestStoragePermission() async {
    // Request both read and write permissions for Android
    if (Platform.isAndroid) {
      final status = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      // Check if all permissions are granted
      final allGranted = status.values.every((status) => status.isGranted);

      if (!allGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permissions are required to download files")),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _PDFViewer(String url) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Request permission if needed
      final hasPermissions = await _requestStoragePermission();
      if (!hasPermissions) {
        setState(() => _isLoading = false);
        return;
      }

      // Use DefaultCacheManager to get the file from URL
      File downloadedFile = await DefaultCacheManager().getSingleFile(url);
      print("File downloaded to: ${downloadedFile.path}");

      // Load PDF from downloaded file
      PDFDocument document = await PDFDocument.fromFile(downloadedFile);

      setState(() {
        _document = document;
        _isLoading = false;
      });
    } catch (e) {
      print("Error in loading PDF: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading PDF: $e")),
      );
    }
  }

  Future<void> downloadPdfWithPath(String url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Attempting to download from: $url");

      // Request permissions first
      final hasPermissions = await _requestStoragePermission();
      if (!hasPermissions) {
        setState(() => _isLoading = false);
        return;
      }

      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      print("Selected Directory: $selectedDirectory");

      if (selectedDirectory != null) {
        try {
          // Download file to temporary directory first
          final tempDir = await getTemporaryDirectory();
          final tempPath = '${tempDir.path}/${widget.filename}.pdf';

          print("Starting file download...");
          File downloadedFile = await DefaultCacheManager().getSingleFile(url);

          // Create the destination directory if it doesn't exist
          final destinationPath = '$selectedDirectory/${widget.filename}.pdf';
          final destinationDir = Directory(selectedDirectory);
          if (!await destinationDir.exists()) {
            await destinationDir.create(recursive: true);
          }

          // Copy file to destination
          print("Copying file to: $destinationPath");
          final File newFile = await downloadedFile.copy(destinationPath);

          // Verify file was created
          if (await newFile.exists()) {
            print("File copied successfully!");

            // Load PDF for preview
            PDFDocument document = await PDFDocument.fromFile(newFile);
            setState(() {
              _document = document;
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("PDF downloaded successfully!")),
            );
          } else {
            throw Exception("File was not created at destination");
          }
        } catch (e) {
          print("Error in file download or saving: $e");
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error saving PDF: ${e.toString()}")),
          );
        }
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Download canceled.")),
        );
      }
    } catch (e) {
      print("Overall error: $e");
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading PDF: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34B89B),
        title: const Text("View Notes"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _searchResultsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No notes found for the selected filters.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(data["name"] ?? "Unnamed File"),
                  subtitle: Text("Filename: ${widget.filename}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, color: Colors.blue),
                    onPressed: () {
                      print("Download link: ${data["url"]}");
                      downloadPdfWithPath(data["url"]);
                    },
                  ),

                  onTap: () async {
                    // Show loading screen
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    );

                    // Load PDF
                    await _PDFViewer(data["url"]);

                    // Close loading screen
                    Navigator.pop(context);

                    if (_document != null) {
                      // Navigate to PDF viewer screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerScreen(
                            document: _document!,
                            title: data["name"] ?? "PDF Viewer",
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}