
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Information/accounts.dart';

class ViewTutorList extends StatefulWidget {
  final List<DocumentSnapshot> tutors; // Accept the list of tutors
  final String selectedSubject; // Selected subject filter
  final String selectedCity; // Selected city filter
  final String selectedClass; // Selected class filter

  const ViewTutorList({
    super.key,
    required this.tutors,
    required this.selectedSubject,
    required this.selectedCity,
    required this.selectedClass,
  });

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

          // Determine if the fields match the selected filters
          final isSubjectMatch = tutor['subject'] == widget.selectedSubject;
          final isCityMatch = tutor['location'] == widget.selectedCity;
          final isClassMatch = tutor['classes'] == widget.selectedClass;

          return Card(
            margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),

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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      isSubjectMatch ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email: ${tutor['email'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Class: ${tutor['classes'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isClassMatch ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'City: ${tutor['location'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCityMatch ? FontWeight.bold : FontWeight.normal,
                    ),
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

