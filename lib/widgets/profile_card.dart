import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../models/models.dart';
import 'premium_badge.dart';
import 'interest_button.dart';
import '../services/supabase_service.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onTap;
  final Future<void> Function() onSendInterest;
  final bool initialSent;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    required this.onSendInterest,
    required this.initialSent,
  });

  @override
  Widget build(BuildContext context) {
    final SupabaseService dbService = Get.find<SupabaseService>();

    return Card(
      elevation: 3,
      shadowColor: AppColors.primaryMaroon.withOpacity(0.04),
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with badges & lock
            Stack(
              children: [
                // Profile Image with caching and optional blur lock
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CachedNetworkImage(
                    imageUrl: profile.photoUrls.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceCreamDim.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryMaroon),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceCreamDim,
                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    imageBuilder: (context, imageProvider) {
                      // Apply blur filter if photo is locked and current user is not premium
                      final bool shouldBlur = profile.photosLocked &&
                          !(dbService.currentUser.value?.isPremium ?? false);

                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: shouldBlur
                            ? ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.2),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.lock_outline,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Unlock Photo with Premium',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
                
                // Bottom Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.4],
                      ),
                    ),
                  ),
                ),

                // Name, Age and Badges overlay
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${profile.name}, ${profile.age}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (profile.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const VerificationBadge(size: 18),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.religion} • ${profile.community}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (profile.isPremium) const PremiumBadge(size: 14),
                    ],
                  ),
                ),
              ],
            ),
            
            // Detail / Text Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.work_outline, size: 14, color: AppColors.secondaryGold),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          profile.profession,
                          style: TextStyle(
                            color: AppColors.textDarkMuted,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondaryGold),
                      const SizedBox(width: 4),
                      Text(
                        profile.location.split(',').first,
                        style: TextStyle(
                          color: AppColors.textDarkMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Tags Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildChip(profile.education.split(',').first),
                      _buildChip(profile.motherTongue),
                      _buildChip('${profile.height.toInt()} cm'),
                      _buildChip('₹${profile.salary} LPA'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Send Interest Button and View Profile text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: onTap,
                        child: const Text(
                          'View Profile',
                          style: TextStyle(
                            color: AppColors.primaryMaroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InterestButton(
                        profileId: profile.id,
                        profileName: profile.name,
                        profilePhotoUrl: profile.photoUrls.first,
                        initialSent: initialSent,
                        onSendInterest: onSendInterest,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tertiaryPink.withOpacity(0.25),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryMaroon,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
