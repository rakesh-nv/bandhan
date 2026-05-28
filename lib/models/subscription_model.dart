class SubscriptionModel {
  final String id;
  final String userId;
  final String planName;
  final double amount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String paymentStatus;
  final String? paymentId;
  final DateTime? createdAt;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planName,
    required this.amount,
    this.startDate,
    this.endDate,
    required this.paymentStatus,
    this.paymentId,
    this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      planName: json['plan_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      startDate: json['start_date'] != null ? DateTime.tryParse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date'] as String) : null,
      paymentStatus: json['payment_status'] as String,
      paymentId: json['payment_id'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_name': planName,
      'amount': amount,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'payment_status': paymentStatus,
      'payment_id': paymentId,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? planName,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    String? paymentStatus,
    String? paymentId,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planName: planName ?? this.planName,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
