import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../routes/routes.dart';
import '../../widgets/profile_card.dart';
import '../../widgets/loading_skeleton.dart';
import 'hub_controller.dart';

class RecommendationsTab extends GetView<HubController> {
  const RecommendationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.loadFeeds(),
      color: AppColors.primaryMaroon,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Search Bar
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  border: Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryMaroon.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: AppColors.primaryMaroon),
                    SizedBox(width: 12),
                    Text(
                      'Search by age, community, profession...',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Spacer(),
                    Icon(Icons.tune, color: AppColors.primaryMaroon),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Premium Carousel Banner
            _buildPremiumCarousel(context),
            const SizedBox(height: 32),

            // Tabs / Recommendations feed
            Obx(() {
              if (controller.isLoadingFeed.value) {
                return Column(
                  children: const [
                    MatchCardSkeleton(),
                    MatchCardSkeleton(),
                  ],
                );
              }

              if (controller.recommendations.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No matching profiles found.',
                      style: TextStyle(color: AppColors.textDarkMuted),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Daily Recommendations
                  _buildSectionHeader(
                    context,
                    title: 'Daily Recommendations',
                    subtitle: 'Curated matches matching your preferences',
                  ),
                  const SizedBox(height: 8),
                  ...controller.recommendations.map((profile) {
                    return Obx(() {
                      final isSent = controller.isInterestSent(profile.id);
                      return ProfileCard(
                        profile: profile,
                        initialSent: isSent,
                        onTap: () => Get.toNamed(AppRoutes.profileDetails, arguments: profile),
                        onSendInterest: () => controller.sendInterest(profile.id),
                      );
                    });
                  }).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // Section: Verified & Nearby highlights
                  _buildSectionHeader(
                    context,
                    title: 'Verified Profiles Near You',
                    subtitle: 'Trustworthy matches in your region',
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.nearbyMatches.length,
                      itemBuilder: (context, index) {
                        final profile = controller.nearbyMatches[index];
                        return GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.profileDetails, arguments: profile),
                          child: Container(
                            width: 110,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(AppRadius.card),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                                  child: Image.network(
                                    profile.profilePhoto ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80',
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: double.infinity,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (profile.fullName ?? 'User').split(' ').first,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${profile.age ?? 25} yrs • ${(profile.community ?? 'Not specified').split(' ').first}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textDarkMuted),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMaroon,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textDarkMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCarousel(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        onPageChanged: (index) => controller.carouselIndex.value = index,
        itemCount: controller.banners.length,
        itemBuilder: (context, index) {
          final banner = controller.banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.maroonGradient,
              borderRadius: BorderRadius.circular(AppRadius.container),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryMaroon.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner['title']!,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.secondaryGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner['subtitle']!,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.subscription),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            banner['cta']!,
                            style: const TextStyle(
                              color: AppColors.primaryMaroon,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.stars,
                  color: AppColors.secondaryGold,
                  size: 64,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
