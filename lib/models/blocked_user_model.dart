class BlockedUserModel {
  final String id;
  final String blockerId;
  final String blockedId;
  final DateTime? createdAt;

  BlockedUserModel({
    required this.id,
    required this.blockerId,
    required this.blockedId,
    this.createdAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['id'] as String,
      blockerId: json['blocker_id'] as String,
      blockedId: json['blocked_id'] as String,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blocker_id': blockerId,
      'blocked_id': blockedId,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  BlockedUserModel copyWith({
    String? id,
    String? blockerId,
    String? blockedId,
    DateTime? createdAt,
  }) {
    return BlockedUserModel(
      id: id ?? this.id,
      blockerId: blockerId ?? this.blockerId,
      blockedId: blockedId ?? this.blockedId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
