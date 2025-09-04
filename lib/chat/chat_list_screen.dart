import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_room.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';
import 'new_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();
  String? currentUserRole;
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserData();
  }

  Future<void> _fetchCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      
      if (userDoc.exists) {
        setState(() {
          currentUserRole = userDoc.data()!['role'];
          currentUserName = userDoc.data()!['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: const Color(0xFF34B89B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (currentUserRole != null) {
                Get.to(() => NewChatScreen(currentUserRole: currentUserRole!));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatService.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final chatRooms = snapshot.data ?? [];

          if (chatRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No chats yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation with a ${currentUserRole == 'Student' ? 'tutor' : 'student'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (currentUserRole != null) {
                        Get.to(() => NewChatScreen(currentUserRole: currentUserRole!));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start New Chat'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final otherParticipantId = chatRoom.getOtherParticipantId(_chatService.currentUserId);
              final otherParticipantName = chatRoom.getOtherParticipantName(_chatService.currentUserId);
              final otherParticipantRole = chatRoom.getOtherParticipantRole(_chatService.currentUserId);

              return ChatRoomTile(
                chatRoom: chatRoom,
                otherParticipantName: otherParticipantName,
                otherParticipantRole: otherParticipantRole,
                onTap: () {
                  Get.to(() => ChatScreen(
                    chatRoomId: chatRoom.id,
                    otherParticipantName: otherParticipantName,
                    otherParticipantRole: otherParticipantRole,
                  ));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentUserRole != null) {
            Get.to(() => NewChatScreen(currentUserRole: currentUserRole!));
          }
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final String otherParticipantName;
  final String otherParticipantRole;
  final VoidCallback onTap;

  const ChatRoomTile({
    Key? key,
    required this.chatRoom,
    required this.otherParticipantName,
    required this.otherParticipantRole,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getRoleColor(otherParticipantRole),
        child: Text(
          otherParticipantName.isNotEmpty ? otherParticipantName[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              otherParticipantName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (chatRoom.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${chatRoom.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            otherParticipantRole,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            chatRoom.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: chatRoom.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
              fontWeight: chatRoom.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
      trailing: Text(
        _formatTime(chatRoom.lastMessageTime),
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'tutor':
        return Colors.blue;
      case 'student':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}

