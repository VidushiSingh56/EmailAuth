
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Information/accounts.dart';
import '../chat/chat_screen.dart';
import '../services/chat_service.dart';

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
  final ChatService _chatService = ChatService();

  Future<void> _startChat(DocumentSnapshot tutor) async {
    try {
      final chatRoomId = await _chatService.createOrGetChatRoom(
        otherUserId: tutor.id,
        otherUserName: tutor['name'] ?? 'Unknown',
        otherUserRole: 'Tutor',
      );

      Get.to(() => ChatScreen(
        chatRoomId: chatRoomId,
        otherParticipantName: tutor['name'] ?? 'Unknown',
        otherParticipantRole: 'Tutor',
      ));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start chat: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void _viewProfile(DocumentSnapshot tutor) {
    // You can implement profile view functionality here
    Get.snackbar(
      'Profile',
      'Viewing profile of ${tutor['name']}',
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _startChat(tutor),
                          icon: const Icon(Icons.chat, color: Colors.white),
                          label: const Text(
                            'Start Chat',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _viewProfile(tutor),
                          icon: const Icon(Icons.person, color: Colors.white),
                          label: const Text(
                            'View Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
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

