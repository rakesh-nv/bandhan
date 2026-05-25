import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import 'checkout_dialog.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of mock subscription plans
    final List<Map<String, dynamic>> plans = [
      {
        'id': 'plan_gold',
        'name': 'Golden Bandhan',
        'price': '₹1,499',
        'duration': '3 Months',
        'isPopular': true,
        'color': AppColors.primaryMaroon,
        'benefits': [
          'Send Unlimited Interests',
          'Unlock Direct Chat with Matches',
          'View Verified Contact Numbers',
          'See Who Viewed Your Profile',
          'Standard Community Matches'
        ]
      },
      {
        'id': 'plan_diamond',
        'name': 'Diamond Milan',
        'price': '₹2,999',
        'duration': '6 Months',
        'isPopular': false,
        'color': AppColors.secondaryGold,
        'benefits': [
          'Everything in Golden Bandhan',
          'Astrological Gun Milan Reports',
          'Profile Booster (3x Visibility)',
          'Dedicated Relationship Advisor',
          'Priority Verified Badge Access'
        ]
      }
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      appBar: AppBar(
        title: Text(
          'Premium Membership',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primaryMaroon,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryMaroon),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryGold.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      color: AppColors.secondaryGold,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connect with Community Matches',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get access to direct chat, detailed horoscope matching, and verify contact profiles.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textDarkMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Plan List Carousel/Grid
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return _buildPlanCard(context, plan);
              },
            ),

            const SizedBox(height: 16),

            // Free Plan info details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Text(
                'By choosing a plan, you agree to Bandhan\'s Terms of Use & Privacy Policy. Subscriptions are billed one-time and do not auto-renew.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.textDarkMuted.withOpacity(0.8),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan) {
    final bool isPopular = plan['isPopular'];
    final Color headerColor = plan['color'];
    final List<String> benefits = plan['benefits'];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPopular ? AppColors.primaryMaroon : Colors.transparent,
          width: isPopular ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Header banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: headerColor.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPopular) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMaroon,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'MOST POPULAR',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      plan['name'],
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Duration: ${plan['duration']}',
                      style: GoogleFonts.inter(
                        color: AppColors.textDarkMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan['price'],
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.primaryMaroon,
                      ),
                    ),
                    Text(
                      'One-time pay',
                      style: GoogleFonts.inter(
                        color: AppColors.textDarkMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Plan benefits list
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          benefit,
                          style: GoogleFonts.inter(
                            color: AppColors.textDark,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 20),
                
                // Upgrade CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openCheckout(context, plan['name'], plan['price']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: headerColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      'Upgrade to ${plan['name']}',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCheckout(BuildContext context, String planName, String price) async {
    final result = await Get.dialog(
      CheckoutDialog(planName: planName, price: price),
      barrierDismissible: false,
    );

    if (result == true) {
      Get.back(); // Return back to home hub on payment completion
    }
  }
}
