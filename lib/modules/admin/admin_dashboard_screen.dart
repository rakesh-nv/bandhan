import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Admin mock states
  final RxList<Map<String, dynamic>> pendingVerifications = <Map<String, dynamic>>[
    {
      'id': 'mod_1',
      'name': 'Kriti Sen',
      'age': 29,
      'community': 'Kayastha',
      'location': 'Bengaluru',
      'idType': 'Aadhaar Card',
      'idDocUrl': 'https://images.unsplash.com/photo-1554774853-aae0a22c8aa4?w=500&fit=crop&q=80',
      'photoUrl': AppPlaceholderImages.avatarFemale3,
    },
    {
      'id': 'mod_2',
      'name': 'Sanjay Verma',
      'age': 32,
      'community': 'Brahmin',
      'location': 'Delhi NCR',
      'idType': 'Passport',
      'idDocUrl': 'https://images.unsplash.com/photo-1554774853-aae0a22c8aa4?w=500&fit=crop&q=80',
      'photoUrl': AppPlaceholderImages.avatarMale3,
    }
  ].obs;

  final RxList<Map<String, dynamic>> flaggedReports = <Map<String, dynamic>>[
    {
      'id': 'rep_1',
      'reportedUser': 'Amit Patel',
      'reporter': 'Preeti S.',
      'reason': 'Abusive language and requesting private number repeatedly.',
      'date': '3 hours ago',
      'photoUrl': AppPlaceholderImages.avatarMale4,
    },
    {
      'id': 'rep_2',
      'reportedUser': 'Sneha Rao',
      'reporter': 'Karan M.',
      'reason': 'Fake account using downloaded pictures of a model.',
      'date': '1 day ago',
      'photoUrl': AppPlaceholderImages.avatarFemale2,
    }
  ].obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      appBar: AppBar(
        title: Text(
          'Admin Moderation Desk',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primaryMaroon,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondaryGold,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(child: Text('Overview', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold))),
            Tab(child: Text('Verify IDs', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold))),
            Tab(child: Text('Flagged Logs', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildVerificationTab(),
          _buildFlaggedTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Metrics',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                title: 'Total Matches',
                value: '1,429',
                icon: Icons.people,
                color: Colors.blue,
              ),
              _buildStatCard(
                title: 'Pending Verification',
                value: '${pendingVerifications.length}',
                icon: Icons.verified_user,
                color: AppColors.secondaryGold,
              ),
              _buildStatCard(
                title: 'Reported Flags',
                value: '${flaggedReports.length}',
                icon: Icons.flag,
                color: AppColors.errorRed,
              ),
              _buildStatCard(
                title: 'Monthly Premium',
                value: '₹1,56,800',
                icon: Icons.monetization_on,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Community Registration Growth',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Custom visual chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New registrations (This Week)',
                      style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 12),
                    ),
                    Text(
                      '+24% vs Last Week',
                      style: GoogleFonts.inter(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Chart Columns
                SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar('Mon', 45, 150),
                      _buildChartBar('Tue', 65, 150),
                      _buildChartBar('Wed', 95, 150),
                      _buildChartBar('Thu', 110, 150),
                      _buildChartBar('Fri', 85, 150),
                      _buildChartBar('Sat', 125, 150),
                      _buildChartBar('Sun', 140, 150),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.textDarkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double value, double maxVal) {
    final double heightPct = value / maxVal;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${value.toInt()}',
          style: GoogleFonts.inter(fontSize: 9, color: AppColors.textDarkMuted),
        ),
        const SizedBox(height: 4),
        Container(
          width: 22,
          height: 100 * heightPct,
          decoration: BoxDecoration(
            color: AppColors.primaryMaroon,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            gradient: LinearGradient(
              colors: [AppColors.primaryMaroon, AppColors.primaryMaroon.withOpacity(0.7)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildVerificationTab() {
    return Obx(() {
      if (pendingVerifications.isEmpty) {
        return const Center(
          child: Text('Verification queue is empty. All users verified!'),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: pendingVerifications.length,
        itemBuilder: (context, index) {
          final item = pendingVerifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(item['photoUrl']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '${item['age']} yrs • ${item['community']} • ${item['location']}',
                              style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Identity document verification details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Type: ${item['idType']}',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryMaroon),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['idDocUrl'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          pendingVerifications.removeAt(index);
                          Get.snackbar('Rejected', 'Verification request rejected.',
                              backgroundColor: AppColors.errorRed, colorText: Colors.white);
                        },
                        child: Text(
                          'Decline Document',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.errorRed, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          pendingVerifications.removeAt(index);
                          Get.snackbar('Approved', 'Verification badge activated.',
                              backgroundColor: Colors.green, colorText: Colors.white);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMaroon,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'Approve ID Shield',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFlaggedTab() {
    return Obx(() {
      if (flaggedReports.isEmpty) {
        return const Center(
          child: Text('No flagged reports active. Clean community desk!'),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: flaggedReports.length,
        itemBuilder: (context, index) {
          final item = flaggedReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(item['photoUrl']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Flagged User: ',
                                    style: GoogleFonts.plusJakartaSans(color: AppColors.textDarkMuted, fontSize: 13),
                                  ),
                                  TextSpan(
                                    text: item['reportedUser'],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Reported by: ${item['reporter']} • ${item['date']}',
                              style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Report Reason Content Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.errorRed.withOpacity(0.1)),
                    ),
                    child: Text(
                      '"${item['reason']}"',
                      style: GoogleFonts.inter(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          flaggedReports.removeAt(index);
                          Get.snackbar('Dismissed', 'Report dismissed.',
                              backgroundColor: Colors.grey[800], colorText: Colors.white);
                        },
                        child: Text(
                          'Dismiss Warning',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.textDarkMuted, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          flaggedReports.removeAt(index);
                          Get.snackbar('Suspended', 'User profile suspended from matching index.',
                              backgroundColor: AppColors.errorRed, colorText: Colors.white);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'Suspend Account',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
