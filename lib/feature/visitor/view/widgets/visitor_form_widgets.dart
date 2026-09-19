import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared visual language for the visitor pass form: one surface card,
/// one field radius, one label style.
class VisitorFormTheme {
  const VisitorFormTheme._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surface(BuildContext context) =>
      isDark(context) ? const Color(0xFF0C0F13) : AppColors.whiteColor;

  static Color field(BuildContext context) =>
      isDark(context) ? const Color(0xFF111418) : AppColors.secondaryColor;

  static Color border(BuildContext context) =>
      isDark(context) ? const Color(0xFF1F242B) : const Color(0xFFE3E7EE);

  static Color hint(BuildContext context) => isDark(context)
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary;

  static BorderRadius get fieldRadius =>
      BorderRadius.all(Radius.circular(14.r));
}

/// Card that groups the visitor pass inputs so the screen reads as one block
/// instead of loose fields floating on the background.
class VisitorSectionCard extends StatelessWidget {
  const VisitorSectionCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bool darkTheme = VisitorFormTheme.isDark(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: VisitorFormTheme.surface(context),
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        border: Border.all(color: VisitorFormTheme.border(context)),
        boxShadow: darkTheme
            ? null
            : [
                BoxShadow(
                  color: AppColors.blackColor.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 16.h,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
              ),
              10.pw,
              AppText(title, style: AppStyle.fontSize16Bold(context)),
            ],
          ),
          16.ph,
          ...children,
        ],
      ),
    );
  }
}

/// Small icon + label that sits directly above each input.
class VisitorFieldLabel extends StatelessWidget {
  const VisitorFieldLabel({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primaryColor),
        8.pw,
        Flexible(
          child: AppText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.fontSize14Bold(context),
          ),
        ),
      ],
    );
  }
}

/// Informational strip used for the validity note and empty QR hint.
class VisitorNoteBanner extends StatelessWidget {
  const VisitorNoteBanner({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.primaryColor),
          10.pw,
          Expanded(
            child: AppText(
              message,
              style: AppStyle.fontSize14Regular(
                context,
              ).copyWith(color: VisitorFormTheme.hint(context), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
