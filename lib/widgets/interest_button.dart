import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class InterestButton extends StatefulWidget {
  final String profileId;
  final String profileName;
  final String profilePhotoUrl;
  final bool initialSent;
  final Future<void> Function() onSendInterest;

  const InterestButton({
    super.key,
    required this.profileId,
    required this.profileName,
    required this.profilePhotoUrl,
    this.initialSent = false,
    required this.onSendInterest,
  });

  @override
  State<InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton>
    with SingleTickerProviderStateMixin {
  late bool _isSent;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _isSent = widget.initialSent;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    if (_isSent) return;

    _animController.forward(from: 0);
    setState(() {
      _isSent = true;
    });

    await widget.onSendInterest();
    _showMatchSuccessDialog();
  }

  void _showMatchSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.container),
        ),
        backgroundColor: AppColors.surfaceCream,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryGold.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.heartRed,
                  size: 54,
                ),
              ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              
              Text(
                'Interest Sent!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMaroon,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'We have notified '),
                    TextSpan(
                      text: widget.profileName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryMaroon),
                    ),
                    const TextSpan(text: '. Once they accept your interest, you can start chatting directly!'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMaroon,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('View More Profiles'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.2)
          .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isSent ? Colors.white : AppColors.primaryMaroon,
          foregroundColor: _isSent ? AppColors.primaryMaroon : Colors.white,
          side: _isSent ? const BorderSide(color: AppColors.primaryMaroon, width: 1) : null,
          elevation: _isSent ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        onPressed: _handlePress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isSent ? Icons.done : Icons.favorite,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _isSent ? 'Interest Sent' : 'Send Interest',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
