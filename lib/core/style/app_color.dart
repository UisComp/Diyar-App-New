import 'package:flutter/material.dart';
class AppColors {
  // Brand palette: black-dominant base with electric blue accents.
  static const Color primaryColor = Color(0xFF0084E4);
  static const Color accentHoverColor = Color(0xFF04C0FF);
  static const Color secondaryColor = Color(0xFFF2F4F7);
  static const Color containerColor = Color(0xFFF5F5F5);
  static const Color descContainerColor = Color(0xFF5C5C5C);
  static const Color dividerColor = Color(0xFF0084E4);
  static const Color diyarColor = Color(0xFF795548);

  // Basic text and background colors
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Color(0xFF000000);
  static const Color black87 = Colors.black87;
  static const Color greyColor = Colors.grey;
  static const Color black45Color = Colors.black45;
  static const Color white70Color = Colors.white70;
  static const Color black54Color = Colors.black54;
  static const Color black12Color = Colors.black12;
  static const Color white12Color = Colors.white12;
  // Light theme palette
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF5C5C5C);

  // Dark theme palette
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF0A0A0A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB8B8B8);
  static const Color greenColor = Colors.green;
  static const Color redColor = Colors.red;
  static const Color blueColor = Colors.blue;
  static const Color orangeColor = Colors.orange;
  static const Color yellowColor = Colors.yellow;
  static const Color redAccentColor = Colors.redAccent;

  // Brand gradients
  static const LinearGradient brandHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000),
      Color(0xFF001A2E),
      Color(0xFF003B66),
    ],
    stops: [0.0, 0.65, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0084E4), Color(0xFF04C0FF)],
  );

  static const RadialGradient logoGlowGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.85,
    colors: [
      Color(0x4604C0FF),
      Color(0x220084E4),
      Color(0xFF000000),
    ],
    stops: [0.0, 0.55, 1.0],
  );
}
