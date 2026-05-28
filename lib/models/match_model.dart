class MatchModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime? matchedAt;

  MatchModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.matchedAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      matchedAt: json['matched_at'] != null ? DateTime.tryParse(json['matched_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'matched_at': matchedAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  MatchModel copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? matchedAt,
  }) {
    return MatchModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      matchedAt: matchedAt ?? this.matchedAt,
    );
  }
}
