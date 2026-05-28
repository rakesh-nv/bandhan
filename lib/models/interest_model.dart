import 'profile_model.dart';

class InterestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime? createdAt;
  final ProfileModel? otherProfile;

  InterestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.createdAt,
    this.otherProfile,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  InterestModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? status,
    DateTime? createdAt,
    ProfileModel? otherProfile,
  }) {
    return InterestModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      otherProfile: otherProfile ?? this.otherProfile,
    );
  }
}
