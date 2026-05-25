import 'dart:convert';

enum Gender { male, female }
enum MaritalStatus { neverMarried, divorced, widowed, awaitingDivorce }

class UserProfile {
  final String id;
  final String name;
  final Gender gender;
  final DateTime dateOfBirth;
  final String religion;
  final String community; // Caste/Community
  final String motherTongue;
  final String education;
  final String profession;
  final double salary; // in lakhs/annum
  final double height; // in cm
  final double weight; // in kg
  final MaritalStatus maritalStatus;
  final String location;
  final String bio;
  final String familyDetails;
  final PartnerPreferences partnerPreferences;
  final List<String> photoUrls;
  final bool isVerified;
  final bool isPremium;
  final bool photosLocked;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.religion,
    required this.community,
    required this.motherTongue,
    required this.education,
    required this.profession,
    required this.salary,
    required this.height,
    required this.weight,
    required this.maritalStatus,
    required this.location,
    required this.bio,
    required this.familyDetails,
    required this.partnerPreferences,
    required this.photoUrls,
    this.isVerified = false,
    this.isPremium = false,
    this.photosLocked = false,
    required this.createdAt,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}

class PartnerPreferences {
  final int minAge;
  final int maxAge;
  final double minHeight;
  final double maxHeight;
  final List<String> religions;
  final List<String> communities;
  final List<String> educations;
  final double minSalary;

  PartnerPreferences({
    this.minAge = 18,
    this.maxAge = 70,
    this.minHeight = 120.0,
    this.maxHeight = 220.0,
    this.religions = const [],
    this.communities = const [],
    this.educations = const [],
    this.minSalary = 0.0,
  });
}

class Match {
  final UserProfile profile;
  final double compatibilityPercentage;
  final bool isOnline;
  final String lastActive;

  Match({
    required this.profile,
    this.compatibilityPercentage = 90.0,
    this.isOnline = false,
    this.lastActive = 'Active now',
  });
}

enum InterestStatus { pending, accepted, rejected }

class Interest {
  final String id;
  final String senderId;
  final String receiverId;
  final InterestStatus status;
  final DateTime sentAt;
  final UserProfile otherProfile; // Helper to display context

  Interest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.sentAt,
    required this.otherProfile,
  });
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentAt;
  final bool isRead;
  final String? mediaUrl;
  final bool isAudio;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentAt,
    this.isRead = false,
    this.mediaUrl,
    this.isAudio = false,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String price;
  final String duration;
  final List<String> benefits;
  final bool isPopular;
  final String colorHex;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.benefits,
    this.isPopular = false,
    required this.colorHex,
  });
}
