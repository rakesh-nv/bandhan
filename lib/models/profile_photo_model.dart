class ProfilePhotoModel {
  final String id;
  final String userId;
  final String photoUrl;
  final bool isPrimary;
  final DateTime? createdAt;

  ProfilePhotoModel({
    required this.id,
    required this.userId,
    required this.photoUrl,
    this.isPrimary = false,
    this.createdAt,
  });

  factory ProfilePhotoModel.fromJson(Map<String, dynamic> json) {
    return ProfilePhotoModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      photoUrl: json['photo_url'] as String,
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'photo_url': photoUrl,
      'is_primary': isPrimary,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  ProfilePhotoModel copyWith({
    String? id,
    String? userId,
    String? photoUrl,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return ProfilePhotoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      photoUrl: photoUrl ?? this.photoUrl,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
