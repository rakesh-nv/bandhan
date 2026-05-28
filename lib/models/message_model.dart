class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String message;
  final bool isRead;
  final DateTime? createdAt;

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    this.isRead = false,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatRoomId: json['chat_room_id'] as String,
      senderId: json['sender_id'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  MessageModel copyWith({
    String? id,
    String? chatRoomId,
    String? senderId,
    String? message,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
