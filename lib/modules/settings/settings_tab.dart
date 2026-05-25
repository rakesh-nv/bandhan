import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../routes/routes.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final SupabaseService dbService = Get.find<SupabaseService>();
  
  // Local state for toggles
  bool hideNumber = true;
  bool blurPhotos = false;
  bool manualInterestApproval = true;
  
  bool notifyMatches = true;
  bool notifyInterests = true;
  bool notifyMessages = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildPremiumStatusCard(),
            const SizedBox(height: 16),
            _buildSettingsSection(
              title: 'Privacy Settings',
              children: [
                _buildSwitchTile(
                  icon: Icons.phone_android,
                  title: 'Hide Mobile Number',
                  subtitle: 'Show number only to matches whose interest you accept',
                  value: hideNumber,
                  onChanged: (v) => setState(() => hideNumber = v),
                ),
                _buildSwitchTile(
                  icon: Icons.blur_on,
                  title: 'Blur Photos',
                  subtitle: 'Only verified premium members can view my profile photos',
                  value: blurPhotos,
                  onChanged: (v) => setState(() => blurPhotos = v),
                ),
                _buildSwitchTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Manual Verification Required',
                  subtitle: 'Accept interest requests manually before matching',
                  value: manualInterestApproval,
                  onChanged: (v) => setState(() => manualInterestApproval = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              title: 'Notification Settings',
              children: [
                _buildSwitchTile(
                  icon: Icons.people_outline,
                  title: 'New Matches Alerts',
                  subtitle: 'Receive updates when matches fit your preferences',
                  value: notifyMatches,
                  onChanged: (v) => setState(() => notifyMatches = v),
                ),
                _buildSwitchTile(
                  icon: Icons.favorite_border,
                  title: 'Interests Alerts',
                  subtitle: 'Get notified immediately when someone shows interest',
                  value: notifyInterests,
                  onChanged: (v) => setState(() => notifyInterests = v),
                ),
                _buildSwitchTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Message Alerts',
                  subtitle: 'Instant alerts on new message replies',
                  value: notifyMessages,
                  onChanged: (v) => setState(() => notifyMessages = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              title: 'Account Settings & Security',
              children: [
                _buildActionTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () => _showChangePasswordDialog(),
                ),
                _buildActionTile(
                  icon: Icons.security,
                  title: 'Verify Government ID',
                  subtitle: 'Required to display the Blue Verified Shield Badge',
                  onTap: () {
                    Get.snackbar('Verification', 'Please upload scan copy to verification team.',
                        backgroundColor: AppColors.primaryMaroon, colorText: Colors.white);
                  },
                ),
                _buildActionTile(
                  icon: Icons.delete_forever_outlined,
                  title: 'Delete Account',
                  titleColor: AppColors.errorRed,
                  onTap: () => _showDeleteAccountDialog(),
                ),
                _buildActionTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Get.offAllNamed(AppRoutes.login);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Obx(() {
      final user = dbService.currentUser.value;
      if (user == null) return const SizedBox.shrink();
      
      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.surfaceCreamHigh,
              backgroundImage: user.photoUrls.isNotEmpty ? NetworkImage(user.photoUrls.first) : null,
              child: user.photoUrls.isEmpty ? const Icon(Icons.person, size: 40, color: AppColors.primaryMaroon) : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Colors.blue, size: 18),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.age} yrs • ${user.profession}',
                    style: GoogleFonts.inter(
                      color: AppColors.textDarkMuted,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    user.location,
                    style: GoogleFonts.inter(
                      color: AppColors.textDarkMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPremiumStatusCard() {
    return Obx(() {
      final isPremium = dbService.currentUser.value?.isPremium ?? false;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isPremium ? AppColors.goldGradient : AppColors.maroonGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isPremium ? AppColors.secondaryGold : AppColors.primaryMaroon).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isPremium ? Icons.workspace_premium : Icons.lock_open,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPremium ? 'Golden Membership Active' : 'Basic Membership',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPremium
                        ? 'Unlimited matching interests and Gun Milan unlocked.'
                        : 'Upgrade to send unlimited requests and view contact details.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!isPremium)
              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.subscription),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryMaroon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Upgrade',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildSettingsSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryMaroon,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: AppColors.primaryMaroon, size: 22),
      activeColor: AppColors.primaryMaroon,
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          color: AppColors.textDarkMuted,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.primaryMaroon, size: 22),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: titleColor ?? AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 11),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Change Password', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              style: GoogleFonts.inter(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
              style: GoogleFonts.inter(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              style: GoogleFonts.inter(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppColors.textDarkMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'Password updated successfully.',
                  backgroundColor: Colors.green, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryMaroon),
            child: Text('Update', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.errorRed),
        ),
        content: Text(
          'Are you sure you want to permanently delete your matchmaking account? This action will remove all matches, interests log, and is irreversible.',
          style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Keep Account', style: GoogleFonts.plusJakartaSans(color: AppColors.textDark)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.login);
              Get.snackbar('Deleted', 'Account deleted.',
                  backgroundColor: AppColors.errorRed, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: Text('Delete Permanent', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
