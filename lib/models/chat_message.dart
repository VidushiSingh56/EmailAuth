class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String messageType; // 'text', 'image', 'video', 'audio', 'document'
  final String? fileUrl;
  final String? fileName;
  final String? fileSize;
  final String? fileExtension;
  final int? fileDuration; // For audio/video in seconds

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.messageType = 'text',
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.fileExtension,
    this.fileDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileExtension': fileExtension,
      'fileDuration': fileDuration,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
      messageType: map['messageType'] ?? 'text',
      fileUrl: map['fileUrl'],
      fileName: map['fileName'],
      fileSize: map['fileSize'],
      fileExtension: map['fileExtension'],
      fileDuration: map['fileDuration'],
    );
  }
}

