import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Stitch Premium Heritage Matrimony)
  static const Color primaryMaroon = Color(0xFF7B2D26); // Maroon Primary
  static const Color primaryMaroonDark = Color(0xFF5D1712); // Primary dark
  static const Color secondaryGold = Color(0xFFD4A373); // Gold Accent
  static const Color tertiaryPink = Color(0xFFFCD3D1); // Soft Pink Accent
  
  // Neutral Surfaces
  static const Color surfaceCream = Color(0xFFFFF8F3); // Warm cream base
  static const Color surfaceCreamDim = Color(0xFFE6D8C5);
  static const Color surfaceCreamHigh = Color(0xFFF5E6D3);
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Card base
  
  // Text Colors
  static const Color textDark = Color(0xFF221A0F); // On surface
  static const Color textDarkMuted = Color(0xFF554240); // On surface variant
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color activeGreen = Color(0xFF00BCD5); // Cyan active status
  static const Color heartRed = Color(0xFFED5558); // Like button
  static const Color errorRed = Color(0xFFBA1A1A);
  
  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE2C361), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient maroonGradient = LinearGradient(
    colors: [Color(0xFF7B2D26), Color(0xFF5D1712)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppSpacing {
  static const double base = 8.0;
  static const double gap = 16.0;
  static const double padding = 24.0;
  static const double margin = 20.0;
}

class AppRadius {
  static const double card = 16.0;
  static const double container = 24.0;
  static const double button = 99.0; // Pill shape
  static const double input = 12.0;
}

class AppPlaceholderImages {
  static const String avatarFemale1 = 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&fit=crop&q=80';
  static const String avatarFemale2 = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&fit=crop&q=80';
  static const String avatarFemale3 = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&fit=crop&q=80'; // Men/Women swap
  static const String avatarFemale4 = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&fit=crop&q=80';
  
  static const String avatarMale1 = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80';
  static const String avatarMale2 = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&fit=crop&q=80';
  static const String avatarMale3 = 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=400&fit=crop&q=80';
  static const String avatarMale4 = 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&fit=crop&q=80';

  static const String bannerPremium = 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&fit=crop&q=80';
}
