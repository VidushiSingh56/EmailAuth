import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  // Get current user ID
  String get currentUserId => _auth.currentUser?.uid ?? '';

  // Create or get existing chat room
  Future<String> createOrGetChatRoom({
    required String otherUserId,
    required String otherUserName,
    required String otherUserRole,
  }) async {
    final currentUserId = this.currentUserId;
    if (currentUserId.isEmpty) throw Exception('User not authenticated');

    // Get current user data
    final currentUserDoc = await _firestore.collection('user').doc(currentUserId).get();
    if (!currentUserDoc.exists) throw Exception('Current user not found');

    final currentUserData = currentUserDoc.data()!;
    final currentUserName = currentUserData['name'] ?? 'Unknown';
    final currentUserRole = currentUserData['role'] ?? 'Unknown';

    // Check if chat room already exists
    final existingRoomQuery = await _firestore
        .collection('chatRooms')
        .where('participant1Id', whereIn: [currentUserId, otherUserId])
        .where('participant2Id', whereIn: [currentUserId, otherUserId])
        .get();

    if (existingRoomQuery.docs.isNotEmpty) {
      return existingRoomQuery.docs.first.id;
    }

    // Create new chat room
    final chatRoomId = _uuid.v4();
    final chatRoom = ChatRoom(
      id: chatRoomId,
      participant1Id: currentUserId,
      participant2Id: otherUserId,
      participant1Name: currentUserName,
      participant2Name: otherUserName,
      participant1Role: currentUserRole,
      participant2Role: otherUserRole,
      lastMessageTime: DateTime.now(),
      lastMessage: 'Chat started',
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .set(chatRoom.toMap());

    return chatRoomId;
  }

  // Send a text message
  Future<void> sendMessage({
    required String chatRoomId,
    required String message,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    final currentUserId = this.currentUserId;
    if (currentUserId.isEmpty) throw Exception('User not authenticated');

    final chatMessage = ChatMessage(
      id: _uuid.v4(),
      senderId: currentUserId,
      receiverId: '', // Will be set based on chat room
      message: message,
      timestamp: DateTime.now(),
      messageType: messageType,
      imageUrl: imageUrl,
    );

    await _sendChatMessage(chatRoomId, chatMessage);
  }

  // Send a file message
  Future<void> sendFileMessage({
    required String chatRoomId,
    required String message,
    required String messageType,
    required String fileUrl,
    required String fileName,
    required String fileSize,
    required String fileExtension,
    int? fileDuration,
  }) async {
    final currentUserId = this.currentUserId;
    if (currentUserId.isEmpty) throw Exception('User not authenticated');

    final chatMessage = ChatMessage(
      id: _uuid.v4(),
      senderId: currentUserId,
      receiverId: '', // Will be set based on chat room
      message: message,
      timestamp: DateTime.now(),
      messageType: messageType,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      fileExtension: fileExtension,
      fileDuration: fileDuration,
    );

    await _sendChatMessage(chatRoomId, chatMessage);
  }

  // Helper method to send chat message
  Future<void> _sendChatMessage(String chatRoomId, ChatMessage chatMessage) async {
    // Get chat room to determine receiver
    final chatRoomDoc = await _firestore.collection('chatRooms').doc(chatRoomId).get();
    if (!chatRoomDoc.exists) throw Exception('Chat room not found');

    final chatRoomData = chatRoomDoc.data()!;
    final receiverId = chatRoomData['participant1Id'] == chatMessage.senderId
        ? chatRoomData['participant2Id']
        : chatRoomData['participant1Id'];

    // Update message with receiver ID
    final updatedMessage = ChatMessage(
      id: chatMessage.id,
      senderId: chatMessage.senderId,
      receiverId: receiverId,
      message: chatMessage.message,
      timestamp: chatMessage.timestamp,
      messageType: chatMessage.messageType,
      imageUrl: chatMessage.imageUrl,
      fileUrl: chatMessage.fileUrl,
      fileName: chatMessage.fileName,
      fileSize: chatMessage.fileSize,
      fileExtension: chatMessage.fileExtension,
      fileDuration: chatMessage.fileDuration,
    );

    // Add message to chat room
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(chatMessage.id)
        .set(updatedMessage.toMap());

    // Update chat room with last message info
    String lastMessageText = chatMessage.message.isNotEmpty 
        ? chatMessage.message 
        : '${chatMessage.messageType.toUpperCase()} file';
        
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': lastMessageText,
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
      'unreadCount': FieldValue.increment(1),
    });
  }

  // Get messages for a chat room
  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();
    });
  }

  // Get chat rooms for current user
  Stream<List<ChatRoom>> getChatRooms() {
    final currentUserId = this.currentUserId;
    if (currentUserId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('chatRooms')
        .where('participant1Id', isEqualTo: currentUserId)
        .snapshots()
        .asyncMap((snapshot1) async {
      final rooms1 = snapshot1.docs.map((doc) => ChatRoom.fromMap(doc.data())).toList();

      final snapshot2 = await _firestore
          .collection('chatRooms')
          .where('participant2Id', isEqualTo: currentUserId)
          .get();

      final rooms2 = snapshot2.docs.map((doc) => ChatRoom.fromMap(doc.data())).toList();

      final allRooms = [...rooms1, ...rooms2];
      allRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      return allRooms;
    });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatRoomId) async {
    final currentUserId = this.currentUserId;
    if (currentUserId.isEmpty) return;

    // Get unread messages for current user
    final unreadMessages = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

    // Mark them as read
    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();

    // Reset unread count
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'unreadCount': 0,
    });
  }

  // Delete chat room
  Future<void> deleteChatRoom(String chatRoomId) async {
    // Delete all messages in the chat room
    final messages = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .get();

    final batch = _firestore.batch();
    for (final doc in messages.docs) {
      batch.delete(doc.reference);
    }

    // Delete the chat room
    batch.delete(_firestore.collection('chatRooms').doc(chatRoomId));
    await batch.commit();
  }

  // Search users for starting new chats
  Future<List<Map<String, dynamic>>> searchUsers(String query, String currentUserRole) async {
    if (query.isEmpty) return [];

    final currentUserId = this.currentUserId;
    if (currentUserId.isEmpty) return [];

    // Search for users with different roles
    String searchRole = currentUserRole == 'Student' ? 'Tutor' : 'Student';

    // final querySnapshot = await _firestore
    //     .collection('user')
    //     .where('role', isEqualTo: searchRole)
    //     .get();
    final querySnapshot = await _firestore
        .collection('user')
        .get();

    final users = <Map<String, dynamic>>[];
    for (final doc in querySnapshot.docs) {
      final userData = doc.data();
      final userName = userData['name']?.toString().toLowerCase() ?? '';
      final userLocation = userData['location']?.toString().toLowerCase() ?? '';
      final userSubject = userData['subject']?.toString().toLowerCase() ?? '';

      if (userName.contains(query.toLowerCase()) ||
          userLocation.contains(query.toLowerCase()) ||
          userSubject.contains(query.toLowerCase())) {
        users.add({
          'id': doc.id,
          'name': userData['name'] ?? 'Unknown',
          'role': userData['role'] ?? 'Unknown',
          'location': userData['location'] ?? '',
          'subject': userData['subject'] ?? '',
          'email': userData['email'] ?? '',
        });
      }
    }

    return users;
  }
}

