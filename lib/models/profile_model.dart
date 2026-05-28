class ProfileModel {
  final String id;
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final int? age;
  final String? community;
  final String? religion;
  final String? caste;
  final String? profession;
  final String? education;
  final String? companyName;
  final String? city;
  final String? state;
  final String? country;
  final String? bio;
  final String? phoneNumber;
  final String? email;
  final String? profilePhoto;
  final bool isPremium;
  final DateTime? premiumStartDate;
  final DateTime? premiumEndDate;
  final bool isVerified;
  final bool isProfileCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    required this.id,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.age,
    this.community,
    this.religion,
    this.caste,
    this.profession,
    this.education,
    this.companyName,
    this.city,
    this.state,
    this.country,
    this.bio,
    this.phoneNumber,
    this.email,
    this.profilePhoto,
    this.isPremium = false,
    this.premiumStartDate,
    this.premiumEndDate,
    this.isVerified = false,
    this.isProfileCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] != null ? DateTime.tryParse(json['date_of_birth'] as String) : null,
      age: json['age'] as int?,
      community: json['community'] as String?,
      religion: json['religion'] as String?,
      caste: json['caste'] as String?,
      profession: json['profession'] as String?,
      education: json['education'] as String?,
      companyName: json['company_name'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      premiumStartDate: json['premium_start_date'] != null ? DateTime.tryParse(json['premium_start_date'] as String) : null,
      premiumEndDate: json['premium_end_date'] != null ? DateTime.tryParse(json['premium_end_date'] as String) : null,
      isVerified: json['is_verified'] as bool? ?? false,
      isProfileCompleted: json['is_profile_completed'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'age': age,
      'community': community,
      'religion': religion,
      'caste': caste,
      'profession': profession,
      'education': education,
      'company_name': companyName,
      'city': city,
      'state': state,
      'country': country,
      'bio': bio,
      'phone_number': phoneNumber,
      'email': email,
      'profile_photo': profilePhoto,
      'is_premium': isPremium,
      'premium_start_date': premiumStartDate?.toIso8601String(),
      'premium_end_date': premiumEndDate?.toIso8601String(),
      'is_verified': isVerified,
      'is_profile_completed': isProfileCompleted,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? gender,
    DateTime? dateOfBirth,
    int? age,
    String? community,
    String? religion,
    String? caste,
    String? profession,
    String? education,
    String? companyName,
    String? city,
    String? state,
    String? country,
    String? bio,
    String? phoneNumber,
    String? email,
    String? profilePhoto,
    bool? isPremium,
    DateTime? premiumStartDate,
    DateTime? premiumEndDate,
    bool? isVerified,
    bool? isProfileCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      community: community ?? this.community,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      profession: profession ?? this.profession,
      education: education ?? this.education,
      companyName: companyName ?? this.companyName,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isPremium: isPremium ?? this.isPremium,
      premiumStartDate: premiumStartDate ?? this.premiumStartDate,
      premiumEndDate: premiumEndDate ?? this.premiumEndDate,
      isVerified: isVerified ?? this.isVerified,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
