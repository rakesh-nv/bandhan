import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../../widgets/premium_badge.dart';
import 'profile_details_controller.dart';
import '../../routes/routes.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileDetailsController());
    final profile = controller.profile;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const BackButton(color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 18),
              onPressed: controller.shareProfile,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Photo Gallery Section
                _buildPhotoGallery(context, controller),
                
                // Profile Body Details
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bio Section
                      _buildHeaderSection(context, controller),
                      const SizedBox(height: 24),
                      
                      _buildInfoBlock(
                        context,
                        title: 'About Me',
                        child: Text(
                          profile.bio ?? 'No bio provided.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textDark,
                                height: 1.4,
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Basic Info Grid
                      _buildInfoBlock(
                        context,
                        title: 'Basic Details',
                        child: _buildDetailsGrid([
                          _buildDetailItem('Religion', profile.religion ?? 'Not specified'),
                          _buildDetailItem('Community', profile.community ?? 'Not specified'),
                          _buildDetailItem('Caste', profile.caste ?? 'Not specified'),
                          _buildDetailItem('Gender', (profile.gender ?? 'Not specified').capitalizeFirst!),
                          _buildDetailItem('Age', '${profile.age ?? 25} years'),
                          _buildDetailItem('Verification', profile.isVerified ? 'Verified' : 'Pending Verification'),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      
                      // Education & Profession
                      _buildInfoBlock(
                        context,
                        title: 'Education & Career',
                        child: _buildDetailsGrid([
                          _buildDetailItem('Education', profile.education ?? 'Not specified'),
                          _buildDetailItem('Profession', profile.profession ?? 'Not specified'),
                          _buildDetailItem('Company Name', profile.companyName ?? 'Not specified'),
                          _buildDetailItem('Current City', profile.city ?? 'Not specified'),
                          _buildDetailItem('State', profile.state ?? 'Not specified'),
                          _buildDetailItem('Country', profile.country ?? 'Not specified'),
                        ]),
                      ),
                      const SizedBox(height: 24),

                      // Partner Preferences
                      _buildInfoBlock(
                        context,
                        title: 'Partner Preferences',
                        child: _buildDetailsGrid([
                          _buildDetailItem('Preferred Community', profile.community ?? 'Any'),
                          _buildDetailItem('Preferred Religion', profile.religion ?? 'Any'),
                          _buildDetailItem('Preferred Education', profile.education ?? 'Any'),
                          _buildDetailItem('Preferred Profession', profile.profession ?? 'Any'),
                        ]),
                      ),
                      
                      // Bottom Spacer to prevent overlap by glass navigation bar
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Action Bar (Glassmorphic bottom nav drawer)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _buildFloatingActionDrawer(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(BuildContext context, ProfileDetailsController controller) {
    final profile = controller.profile;
    final double screenHeight = MediaQuery.of(context).size.height;
    final photoUrl = profile.profilePhoto ?? '';

    return Stack(
      children: [
        // Gallery PageView
        SizedBox(
          height: screenHeight * 0.5,
          child: PageView.builder(
            onPageChanged: (index) => controller.activePhotoIndex.value = index,
            itemCount: 1,
            itemBuilder: (context, index) {
              return photoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: photoUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surfaceCreamHigh,
                        child: const Center(
                          child: Icon(Icons.person, size: 80, color: AppColors.primaryMaroon),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.surfaceCreamHigh,
                      child: const Center(
                        child: Icon(Icons.person, size: 80, color: AppColors.primaryMaroon),
                      ),
                    );
            },
          ),
        ),

        // Indicator overlay
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 20,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context, ProfileDetailsController controller) {
    final profile = controller.profile;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      profile.fullName ?? 'User',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryMaroon,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (profile.isVerified) ...[
                    const SizedBox(width: 8),
                    const VerificationBadge(size: 20),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${profile.age} yrs • ${profile.religion ?? 'Not specified'} • ${profile.city ?? 'Not specified'}',
                style: const TextStyle(color: AppColors.textDarkMuted, fontSize: 14),
              ),
            ],
          ),
        ),
        if (profile.isPremium) const PremiumBadge(),
      ],
    );
  }

  Widget _buildInfoBlock(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMaroon,
          ),
        ),
        const SizedBox(height: 4),
        const Divider(),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDetailsGrid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 16,
      children: children,
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textDarkMuted, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFloatingActionDrawer(ProfileDetailsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: AppColors.secondaryGold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryMaroon.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.container),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Decline Button
                _buildCircularActionButton(
                  icon: Icons.close,
                  color: Colors.redAccent,
                  onTap: controller.blockUser,
                ),
                const SizedBox(width: 12),
                
                // Shortlist Button
                Obx(() => _buildCircularActionButton(
                      icon: controller.isShortlisted.value ? Icons.star : Icons.star_border,
                      color: AppColors.secondaryGold,
                      onTap: controller.toggleShortlist,
                    )),
                const SizedBox(width: 12),

                // Report button
                _buildCircularActionButton(
                  icon: Icons.flag_outlined,
                  color: Colors.grey,
                  onTap: controller.reportUser,
                ),
                const SizedBox(width: 16),

                // Connect/Send Interest Pill Button
                Expanded(
                  child: Obx(() {
                    final sent = controller.isInterestSent.value;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sent ? Colors.green : AppColors.primaryMaroon,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: sent ? null : controller.sendInterest,
                      child: Text(
                        sent ? 'Pending Request' : 'Send Interest',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
