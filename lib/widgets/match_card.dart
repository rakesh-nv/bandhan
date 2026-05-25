import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../models/models.dart';
import 'premium_badge.dart';

class MatchCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.primaryMaroon.withOpacity(0.04),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: profile.photoUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        if (profile.isVerified) ...[
                          const VerificationBadge(size: 14),
                          const SizedBox(width: 4),
                        ],
                        if (profile.isPremium) ...[
                          const Icon(Icons.star, color: AppColors.secondaryGold, size: 16),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        '${profile.name.split(" ").first}, ${profile.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.profession,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${profile.religion} • ${profile.community}',
                    style: TextStyle(
                      color: AppColors.textDarkMuted,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
