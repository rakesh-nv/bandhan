class ReportModel {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final String reason;
  final String description;
  final DateTime? createdAt;

  ReportModel({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.reason,
    required this.description,
    this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      reportedUserId: json['reported_user_id'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'reported_user_id': reportedUserId,
      'reason': reason,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  ReportModel copyWith({
    String? id,
    String? reporterId,
    String? reportedUserId,
    String? reason,
    String? description,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reportedUserId: reportedUserId ?? this.reportedUserId,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
