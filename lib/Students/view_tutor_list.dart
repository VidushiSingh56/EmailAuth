import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTutorList extends StatefulWidget {
  final List<DocumentSnapshot> tutors; // Accept the list of tutors

  const ViewTutorList({super.key, required this.tutors});

  @override
  State<ViewTutorList> createState() => _ViewTutorListState();
}

class _ViewTutorListState extends State<ViewTutorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resulting Tutors'),
        backgroundColor: const Color(0xFF34B89B),
      ),
      body: widget.tutors.isEmpty
          ? const Center(
        child: Text(
          'No matching tutors found.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: widget.tutors.length,
        itemBuilder: (context, index) {
          final tutor = widget.tutors[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutor['name'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Subject: ${tutor['subject'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email: ${tutor['email'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Class: ${tutor['classes'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'City: ${tutor['location'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Experience: ${tutor['description']} years',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            color: Colors.amber,
          );
        },
      ),
    );
  }
}
