import 'package:get/get.dart';
import '../models/models.dart';
import '../core/constants.dart';

class SupabaseService extends GetxService {
  // Current user state
  final Rx<UserProfile?> currentUser = Rx<UserProfile?>(null);
  
  // Database mocks
  final RxList<UserProfile> mockProfiles = <UserProfile>[].obs;
  final RxList<Interest> mockInterests = <Interest>[].obs;
  final RxList<Message> mockMessages = <Message>[].obs;
  
  Future<SupabaseService> init() async {
    _generateMockData();
    // Default current user (logged-in user)
    currentUser.value = UserProfile(
      id: 'usr_curr',
      name: 'Rahul Sharma',
      gender: Gender.male,
      dateOfBirth: DateTime(1994, 8, 15),
      religion: 'Hindu',
      community: 'Brahmin',
      motherTongue: 'Hindi',
      education: 'M.Tech, IIT Bombay',
      profession: 'Software Architect',
      salary: 32.5,
      height: 180.0,
      weight: 78.0,
      maritalStatus: MaritalStatus.neverMarried,
      location: 'Mumbai, Maharashtra',
      bio: 'Looking for a companion who values trust, family traditions, and has a modern perspective on life. I enjoy hiking, reading, and technology.',
      familyDetails: 'Father is a retired Professor, Mother is a homemaker. Younger sister is married and settled in Pune.',
      partnerPreferences: PartnerPreferences(
        minAge: 24,
        maxAge: 30,
        minHeight: 155.0,
        maxHeight: 175.0,
        religions: ['Hindu'],
        communities: ['Brahmin', 'Kayastha'],
        educations: ['B.Tech', 'M.Tech', 'MBA', 'MD'],
        minSalary: 10.0,
      ),
      photoUrls: [AppPlaceholderImages.avatarMale1],
      isVerified: true,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
    return this;
  }

  void _generateMockData() {
    // Generate verified, nearby, premium matches
    mockProfiles.addAll([
      UserProfile(
        id: 'usr_1',
        name: 'Ananya Iyer',
        gender: Gender.female,
        dateOfBirth: DateTime(1996, 5, 20),
        religion: 'Hindu',
        community: 'Iyer Brahmin',
        motherTongue: 'Tamil',
        education: 'MBA, IIM Ahmedabad',
        profession: 'Product Manager',
        salary: 24.0,
        height: 165.0,
        weight: 55.0,
        maritalStatus: MaritalStatus.neverMarried,
        location: 'Mumbai, Maharashtra',
        bio: 'Passionate about classical dance, writing, and digital innovation. Seeking a partner who is career-oriented, family-centric, and shares a passion for travel.',
        familyDetails: 'Father is an Executive Director at a PSU, Mother is a Carnatic vocalist. One elder brother (Software Engineer in US).',
        partnerPreferences: PartnerPreferences(),
        photoUrls: [
          AppPlaceholderImages.avatarFemale1,
          AppPlaceholderImages.avatarFemale4,
        ],
        isVerified: true,
        isPremium: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      UserProfile(
        id: 'usr_2',
        name: 'Dr. Priyanka Patil',
        gender: Gender.female,
        dateOfBirth: DateTime(1995, 11, 10),
        religion: 'Hindu',
        community: 'Maratha',
        motherTongue: 'Marathi',
        education: 'MD, KEM Hospital',
        profession: 'Pediatrician',
        salary: 18.0,
        height: 160.0,
        weight: 52.0,
        maritalStatus: MaritalStatus.neverMarried,
        location: 'Pune, Maharashtra',
        bio: 'Believer in simple living and high thinking. Love kids, gardening, and long road trips. Looking for someone based in Maharashtra.',
        familyDetails: 'Both parents are doctors running a private hospital in Kolhapur.',
        partnerPreferences: PartnerPreferences(),
        photoUrls: [
          AppPlaceholderImages.avatarFemale2,
        ],
        isVerified: true,
        isPremium: false,
        photosLocked: true, // Blur lock test
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      UserProfile(
        id: 'usr_3',
        name: 'Kriti Sen',
        gender: Gender.female,
        dateOfBirth: DateTime(1997, 2, 14),
        religion: 'Hindu',
        community: 'Kayastha',
        motherTongue: 'Bengali',
        education: 'B.Des, NID Ahmedabad',
        profession: 'UX Designer',
        salary: 15.0,
        height: 170.0,
        weight: 58.0,
        maritalStatus: MaritalStatus.neverMarried,
        location: 'Bengaluru, Karnataka',
        bio: 'Art enthusiast, dog lover, and part-time baker. Looking for a partner who is creative, kind, and open-minded.',
        familyDetails: 'Father is a retired Banker, Mother is a painter. No siblings.',
        partnerPreferences: PartnerPreferences(),
        photoUrls: [
          AppPlaceholderImages.avatarFemale3,
        ],
        isVerified: false,
        isPremium: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      UserProfile(
        id: 'usr_4',
        name: 'Rohan Deshmukh',
        gender: Gender.male,
        dateOfBirth: DateTime(1993, 3, 25),
        religion: 'Hindu',
        community: 'Maratha',
        motherTongue: 'Marathi',
        education: 'MS, Georgia Tech',
        profession: 'Hardware Architect',
        salary: 45.0,
        height: 182.0,
        weight: 80.0,
        maritalStatus: MaritalStatus.neverMarried,
        location: 'Pune, Maharashtra',
        bio: 'Tech enthusiast, runner, and gourmet cook. Looking for a down-to-earth person who enjoys life.',
        familyDetails: 'Father owns a manufacturing business, Mother is a homemaker. One younger brother.',
        partnerPreferences: PartnerPreferences(),
        photoUrls: [
          AppPlaceholderImages.avatarMale2,
        ],
        isVerified: true,
        isPremium: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      UserProfile(
        id: 'usr_5',
        name: 'Preeti Sharma',
        gender: Gender.female,
        dateOfBirth: DateTime(1994, 9, 30),
        religion: 'Hindu',
        community: 'Brahmin',
        motherTongue: 'Hindi',
        education: 'CA, ICAI',
        profession: 'Financial Analyst',
        salary: 22.0,
        height: 158.0,
        weight: 50.0,
        maritalStatus: MaritalStatus.neverMarried,
        location: 'Mumbai, Maharashtra',
        bio: 'I balance spreadsheets by day and read poetry by night. Seeking a progressive partner with a warm heart and solid values.',
        familyDetails: 'Father is a CA, Mother is a teacher. Elder brother is a lawyer.',
        partnerPreferences: PartnerPreferences(),
        photoUrls: [
          AppPlaceholderImages.avatarFemale4,
        ],
        isVerified: true,
        isPremium: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      )
    ]);

    // Initial Interests
    mockInterests.addAll([
      Interest(
        id: 'int_1',
        senderId: 'usr_1', // Ananya sent to current user
        receiverId: 'usr_curr',
        status: InterestStatus.pending,
        sentAt: DateTime.now().subtract(const Duration(hours: 4)),
        otherProfile: mockProfiles[0],
      ),
      Interest(
        id: 'int_2',
        senderId: 'usr_curr', // Current user sent to Preeti
        receiverId: 'usr_5',
        status: InterestStatus.pending,
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
        otherProfile: mockProfiles[4],
      ),
      Interest(
        id: 'int_3',
        senderId: 'usr_curr', // Accepted interest with Dr. Priyanka Patil
        receiverId: 'usr_2',
        status: InterestStatus.accepted,
        sentAt: DateTime.now().subtract(const Duration(days: 2)),
        otherProfile: mockProfiles[1],
      )
    ]);

    // Initial Chat messages with Priyanka (since interest is accepted)
    mockMessages.addAll([
      Message(
        id: 'msg_1',
        senderId: 'usr_2',
        receiverId: 'usr_curr',
        content: 'Hello Rahul! Glad to connect with you.',
        sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'msg_2',
        senderId: 'usr_curr',
        receiverId: 'usr_2',
        content: 'Hi Priyanka, nice to connect with you too! I read about your work as a Pediatrician, it is really inspiring.',
        sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        isRead: true,
      ),
      Message(
        id: 'msg_3',
        senderId: 'usr_2',
        receiverId: 'usr_curr',
        content: 'Thank you! It is a demanding but very rewarding job. What got you into software architecture?',
        sentAt: DateTime.now().subtract(const Duration(minutes: 45)),
        isRead: false,
      )
    ]);
  }

  // Authentication Mock
  Future<bool> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock latency
    return true;
  }

  Future<bool> loginWithOTP(String mobile, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> signup(UserProfile profile, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    currentUser.value = profile;
    mockProfiles.add(profile);
    return true;
  }

  // Interest Methods
  Future<void> sendInterest(String targetUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final profile = mockProfiles.firstWhere((p) => p.id == targetUserId);
    final newInterest = Interest(
      id: 'int_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'usr_curr',
      receiverId: targetUserId,
      status: InterestStatus.pending,
      sentAt: DateTime.now(),
      otherProfile: profile,
    );
    mockInterests.add(newInterest);
  }

  Future<void> acceptInterest(String interestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = mockInterests.indexWhere((i) => i.id == interestId);
    if (index != -1) {
      final old = mockInterests[index];
      mockInterests[index] = Interest(
        id: old.id,
        senderId: old.senderId,
        receiverId: old.receiverId,
        status: InterestStatus.accepted,
        sentAt: old.sentAt,
        otherProfile: old.otherProfile,
      );
    }
  }

  Future<void> rejectInterest(String interestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    mockInterests.removeWhere((i) => i.id == interestId);
  }

  // Messaging Methods
  Future<void> sendMessage(String receiverId, String text, {String? media, bool isAudio = false}) async {
    final newMsg = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'usr_curr',
      receiverId: receiverId,
      content: text,
      sentAt: DateTime.now(),
      isRead: false,
      mediaUrl: media,
      isAudio: isAudio,
    );
    mockMessages.add(newMsg);
  }

  // Premium Activation Mock
  Future<void> activatePremium(String planName) async {
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser.value != null) {
      final old = currentUser.value!;
      currentUser.value = UserProfile(
        id: old.id,
        name: old.name,
        gender: old.gender,
        dateOfBirth: old.dateOfBirth,
        religion: old.religion,
        community: old.community,
        motherTongue: old.motherTongue,
        education: old.education,
        profession: old.profession,
        salary: old.salary,
        height: old.height,
        weight: old.weight,
        maritalStatus: old.maritalStatus,
        location: old.location,
        bio: old.bio,
        familyDetails: old.familyDetails,
        partnerPreferences: old.partnerPreferences,
        photoUrls: old.photoUrls,
        isVerified: old.isVerified,
        isPremium: true, // Now premium!
        createdAt: old.createdAt,
      );
    }
  }
}
