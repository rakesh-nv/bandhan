import 'package:flutter/material.dart';
import '../core/constants.dart';

class PremiumBadge extends StatelessWidget {
  final double size;
  const PremiumBadge({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryGold.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: size - 4,
          ),
          const SizedBox(width: 4),
          Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.white,
              fontSize: size - 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationBadge extends StatelessWidget {
  final double size;
  const VerificationBadge({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: AppColors.activeGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.verified,
        color: Colors.white,
        size: size - 6,
      ),
    );
  }
}
