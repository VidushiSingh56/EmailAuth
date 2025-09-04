class ChatRoom {
  final String id;
  final String participant1Id;
  final String participant2Id;
  final String participant1Name;
  final String participant2Name;
  final String participant1Role;
  final String participant2Role;
  final DateTime lastMessageTime;
  final String lastMessage;
  final int unreadCount;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.participant1Id,
    required this.participant2Id,
    required this.participant1Name,
    required this.participant2Name,
    required this.participant1Role,
    required this.participant2Role,
    required this.lastMessageTime,
    required this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participant1Id': participant1Id,
      'participant2Id': participant2Id,
      'participant1Name': participant1Name,
      'participant2Name': participant2Name,
      'participant1Role': participant1Role,
      'participant2Role': participant2Role,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      participant1Id: map['participant1Id'] ?? '',
      participant2Id: map['participant2Id'] ?? '',
      participant1Name: map['participant1Name'] ?? '',
      participant2Name: map['participant2Name'] ?? '',
      participant1Role: map['participant1Role'] ?? '',
      participant2Role: map['participant2Role'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'] ?? 0),
      lastMessage: map['lastMessage'] ?? '',
      unreadCount: map['unreadCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  String getOtherParticipantId(String currentUserId) {
    return currentUserId == participant1Id ? participant2Id : participant1Id;
  }

  String getOtherParticipantName(String currentUserId) {
    return currentUserId == participant1Id ? participant2Name : participant1Name;
  }

  String getOtherParticipantRole(String currentUserId) {
    return currentUserId == participant1Id ? participant2Role : participant1Role;
  }
}

