class ChatRoomModel {
  final String id;
  final String matchId;
  final DateTime? createdAt;

  ChatRoomModel({
    required this.id,
    required this.matchId,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      matchId: json['match_id'] as String,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  ChatRoomModel copyWith({
    String? id,
    String? matchId,
    DateTime? createdAt,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
