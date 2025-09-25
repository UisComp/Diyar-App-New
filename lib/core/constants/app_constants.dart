import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/profile/view/profile_screen.dart';
import 'package:diyar_app/feature/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Diyar";
  static const String arLanguage = "ar";
  static const String enLanguage = "en";
  static const String translationPath = "assets/translations";
  static List<Locale> supportedLocales = [
    const Locale(enLanguage),
    const Locale(arLanguage),
  ];
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
 static final List<Widget> screens = const [
    SettingsScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  //!App Fonts
  static const String manropeFont = "Manrope";
  static const String newsReaderFont = "NewsReader";
}
   final List<Map<String, dynamic>> services = const [
    {
      "id": 1,
      "type": 1,
      "name": "News ",
      "title": "Premium Cleaning",
      "description":
          "Professional home and office cleaning with eco-friendly products.",
      "image": "assets/images/news.png",
    },
    {
      "id": 2,
      "type": 2,
      "name": "Active Work",
      "title": "Plumbing Repair",
      "description": "Expert plumbers available 24/7 for all kinds of repairs.",
      "image": "assets/images/active_work.png",
    },
    {
      "id": 3,
      "type": 3,
      "name": "Report",
      "title": "Electrician Service",
      "description":
          "Certified electricians for wiring, installations, and repairs.",
      "image": "assets/images/report.png",
    },
    {
      "id": 4,
      "type": 4,

      "name": "New Work",
      "title": "Car Wash",
      "description":
          "Doorstep car washing and detailing service with premium products.",
      "image": "assets/images/new_work.png",
    },
    {
      "id": 5,
      "type": 5,
      "name": "Account Statements",
      "title": "Home Painting",
      "description":
          "Professional painting service with high-quality finishes.",
      "image": "assets/images/account_statement.png",
    },
    {
      "id": 6,
      "type": 6,
      "name": "Add Property",
      "title": "Gardening",
      "description": "Lawn care, landscaping, and gardening services.",
      "image": "assets/images/add_property.png",
    },
    {
      "id": 7,
      "name": "Add Tenant",
      "title": "Pest Control",
      "description": "Safe and effective pest control solutions for your home.",
      "image": "assets/images/add_tenant.png",
    },
    {
      "id": 8,
      "name": "Visitor",
      "title": "Visitor",
      "description": "Air conditioning installation, repair, and maintenance.",
      "image": "assets/images/visitor.png",
    },
    {
      "id": 9,
      "name": "Announcement",
      "title": "Shifting Service",
      "description": "Quick and safe house or office relocation services.",
      "image": "assets/images/announcement.png",
    },
    {
      "id": 10,
      "name": "Emergency",
      "title": "Shifting Service",
      "description": "Quick and safe house or office relocation services.",
      "image": "assets/images/em.png",
    },

    {
      "id": 11,
      "name": "Facility Booking",
      "title": "Facility Booking",
      "description": "Quick and safe house or office relocation services.",
      "image": "assets/images/facility_booking.png",
    },
    {
      "id": 12,
      "name": "Service Providers",
      "title": "Service Providers",
      "description": "Quick and safe house or office relocation services.",
      "image": "assets/images/service_providers.png",
    },
    {
      "id": 13,
      "name": "Committee",
      "title": "Committee",
      "description": "Quick and safe house or office relocation services.",
      "image": "assets/images/committee.png",
    },
    {
      "id": 14,
      "name": "Complain",
      "title": "Complain",
      "description": "Quick and safe house or office relocation services.",
      "image": "assets/images/complain.png",
    },
  ];
  String? getScreenNameByType(int? type) {
    switch (type) {
      case 1:
        return RoutesName.projectDetails;
      case 5:
        return RoutesName.financeScreen; 
      default:
        return null;
    }
  }