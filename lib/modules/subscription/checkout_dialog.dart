import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';

class CheckoutDialog extends StatefulWidget {
  final String planName;
  final String price;

  const CheckoutDialog({
    super.key,
    required this.planName,
    required this.price,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  final SupabaseService dbService = Get.find<SupabaseService>();
  final _formKey = GlobalKey<FormState>();
  
  String selectedMethod = 'card'; // 'card' or 'upi'
  bool isProcessing = false;
  bool isSuccess = false;

  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController upiController = TextEditingController();

  @override
  void dispose() {
    cardNoController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    upiController.dispose();
    super.dispose();
  }

  void _handlePayment() async {
    if (selectedMethod == 'card' && !_formKey.currentState!.validate()) {
      return;
    }
    if (selectedMethod == 'upi' && upiController.text.trim().isEmpty) {
      Get.snackbar('Input Error', 'Please enter a valid UPI ID',
          backgroundColor: AppColors.errorRed, colorText: Colors.white);
      return;
    }

    setState(() {
      isProcessing = true;
    });

    // Simulate gateway delay
    await Future.delayed(const Duration(seconds: 2));

    // Update state to premium in backend mock
    await dbService.activatePremium(widget.planName);

    setState(() {
      isProcessing = false;
      isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSuccess) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.done, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'Congratulations!',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your premium account is now active.',
                style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                'You have unlocked chats, premium matching algorithms, and community search filters.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.textDarkMuted,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(result: true); // Close checkout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMaroon,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Start Matchmaking',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: isProcessing
          ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryMaroon),
                  const SizedBox(height: 20),
                  Text(
                    'Verifying Payment details...',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please do not press back or close the app',
                    style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 11),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Checkout',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.textDark,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E6D9)),
                    const SizedBox(height: 12),
                    
                    // Product details box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCream,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceCreamDim, width: 0.8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.planName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryMaroon,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Complete Matrimony Access',
                                style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            widget.price,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Select payment option
                    Text(
                      'Select Payment Method',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedMethod = 'card'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedMethod == 'card' ? AppColors.tertiaryPink.withOpacity(0.3) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedMethod == 'card' ? AppColors.primaryMaroon : AppColors.surfaceCreamDim,
                                  width: selectedMethod == 'card' ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.credit_card, size: 16, color: selectedMethod == 'card' ? AppColors.primaryMaroon : AppColors.textDarkMuted),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Card',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: selectedMethod == 'card' ? AppColors.primaryMaroon : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedMethod = 'upi'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedMethod == 'upi' ? AppColors.tertiaryPink.withOpacity(0.3) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedMethod == 'upi' ? AppColors.primaryMaroon : AppColors.surfaceCreamDim,
                                  width: selectedMethod == 'upi' ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone_android, size: 16, color: selectedMethod == 'upi' ? AppColors.primaryMaroon : AppColors.textDarkMuted),
                                  const SizedBox(width: 8),
                                  Text(
                                    'UPI / GPay',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: selectedMethod == 'upi' ? AppColors.primaryMaroon : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (selectedMethod == 'card') ...[
                      TextFormField(
                        controller: cardNoController,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
                        decoration: InputDecoration(
                          hintText: 'Card Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixIcon: const Icon(Icons.credit_card, size: 18),
                        ),
                        validator: (v) => (v == null || v.length < 16) ? 'Enter valid 16 digit card number' : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: expiryController,
                              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
                              decoration: InputDecoration(
                                hintText: 'MM/YY',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              validator: (v) => (v == null || !v.contains('/')) ? 'Expiry' : null,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: cvvController,
                              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
                              decoration: InputDecoration(
                                hintText: 'CVV',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              validator: (v) => (v == null || v.length < 3) ? 'CVV' : null,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      TextFormField(
                        controller: upiController,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark),
                        decoration: InputDecoration(
                          hintText: 'e.g. name@upi',
                          labelText: 'UPI ID',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixIcon: const Icon(Icons.alternate_email, size: 18),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handlePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMaroon,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Pay ${widget.price}',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
