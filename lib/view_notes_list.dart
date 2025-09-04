import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectemailauthdec1/pdf_viewer.dart';
import 'package:projectemailauthdec1/widgets/ErrorSnackbar.dart';
import 'package:open_filex/open_filex.dart';

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


  Future<void> _openPdfFromFile(File file, {String? title}) async {
    try {
      PDFDocument document = await PDFDocument.fromFile(file);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            document: document,
            title: title ?? widget.filename,
          ),
        ),
      );
    } catch (e) {
      print("In-app viewer failed: $e");
      // fallback external
      await OpenFilex.open(file.path);
    }
  }


  Future<void> downloadPdfWithPath(String url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request permissions first (only needed for Android < 11 with scoped storage disabled)
      final hasPermissions = await _requestStoragePermission();
      if (!hasPermissions) {
        setState(() => _isLoading = false);
        return;
      }

      // Ask user where to save (Save As dialog)
      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF As...',
        fileName: "${widget.filename}.pdf",
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (savePath == null) {
        CustomRedSnackbar.showSnackbar(
            titleText: "Cancelled", messageText: "The download has been cancelled");
        setState(() => _isLoading = false);
        return;
      }

      // Download to temp first
      File downloadedFile = await DefaultCacheManager().getSingleFile(url);

      // Copy to user-selected path
      final File newFile = await downloadedFile.copy(savePath);

      if (await newFile.exists()) {
        CustomGreenSnackbar.showSnackbar(
            titleText: "Success!!",
            messageText: "PDF saved at ${newFile.path}");

        // ✅ Open inside your in-app PDF viewer
        try {
          PDFDocument document = await PDFDocument.fromFile(newFile);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
                document: document,
                title: widget.filename,
              ),
            ),
          );
        } catch (e) {
          print("In-app viewer failed, opening externally: $e");
          await OpenFilex.open(newFile.path);
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print("Download error: $e");
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading PDF: $e")),
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
                elevation: 1,
                color: Color(0xFFF8C25D),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(data["subject"] ?? "Unnamed File", style: TextStyle(fontWeight : FontWeight.bold)),
                  subtitle: Text("Filename: ${widget.filename}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, color: Colors.black87),
                    onPressed: () {
                      print("Download link: ${data["url"]}");
                      downloadPdfWithPath(data["url"]);
                    },
                  ),

                  onTap: () async {
                    // Show loading dialog
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      },
                    );

                    try {
                      // Download to cache (not Downloads folder, just temp for viewing)
                      File downloadedFile = await DefaultCacheManager().getSingleFile(data["url"]);

                      Navigator.pop(context); // close loading
                      await _openPdfFromFile(downloadedFile, title: data["name"]);
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error opening PDF: $e")),
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