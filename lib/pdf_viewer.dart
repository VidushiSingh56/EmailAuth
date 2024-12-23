import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

class PDFViewerScreen extends StatefulWidget {
  final PDFDocument document;
  final String title;

  const PDFViewerScreen({
    Key? key,
    required this.document,
    required this.title,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int _currentPage = 1;
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    document = widget.document;
  }

  void _showPagePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String pageNumber = '';

        return AlertDialog(
          title: const Text('Go to Page'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter page number',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              pageNumber = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? page = int.tryParse(pageNumber);
                if (page != null && page >= 1) {
                  setState(() {
                    _currentPage = page;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid page number'),
                    ),
                  );
                }
              },
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34B89B),
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pageview),
            onPressed: _showPagePicker,
            tooltip: 'Go to Page',
          ),
        ],
      ),
        body: PDFViewer(
          document: document,
          showPicker: true,
          showNavigation: true,
          zoomSteps: 1,
          enableSwipeNavigation: true,
          pickerButtonColor: const Color(0xFF34B89B),
          // navigationBarColor: Colors.white,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
        ),

    );
  }
}