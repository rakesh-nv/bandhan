import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryMaroon,
        primary: AppColors.primaryMaroon,
        secondary: AppColors.secondaryGold,
        tertiary: AppColors.tertiaryPink,
        surface: AppColors.surfaceCream,
        error: AppColors.errorRed,
      ),
      scaffoldBackgroundColor: AppColors.surfaceCream,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          color: AppColors.textDark,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.textDark,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textDarkMuted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: AppColors.textDark,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textDarkMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 4,
        shadowColor: AppColors.primaryMaroon.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMaroon,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryMaroon,
          side: const BorderSide(color: AppColors.primaryMaroon, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.surfaceCreamDim, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.surfaceCreamDim, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.secondaryGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.textDarkMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
