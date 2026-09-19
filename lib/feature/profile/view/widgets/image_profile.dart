import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:diyar_app/core/formatter/phone_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Profile identity card: avatar, name and contact details, with an edit
/// shortcut. Guests get a sign-in prompt instead.
class ImageProfile extends StatelessWidget {
  const ImageProfile({super.key, required this.profile, required this.isGuest});

  final ProfileData? profile;
  final bool isGuest;

  /// Versions the URL by picture id so a newly uploaded photo isn't served
  /// from the image cache, without refetching on every rebuild.
  static String? _pictureUrl(ProfilePicture? picture) {
    final url = picture?.url;
    if (url == null || url.isEmpty) return null;
    if (picture?.id == null) return url;
    return '$url${url.contains('?') ? '&' : '?'}v=${picture!.id}';
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final name = isGuest ? LocaleKeys.guest.tr() : (profile?.name ?? '');
    final email = profile?.email;
    final phone = profile?.primaryPhone?.phone;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
      decoration: surface.cardDecoration(radius: 20.r),
      child: Column(
        children: [
          _Avatar(
            name: name,
            imageUrl: isGuest ? null : _pictureUrl(profile?.profilePicture),
          ),
          14.ph,
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: surface.textPrimary,
            ),
          ),
          if (isGuest) ...[
            8.ph,
            Text(
              LocaleKeys.guest_profile_desc.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
                color: surface.textSecondary,
              ),
            ),
            18.ph,
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: FilledButton(
                onPressed: () => context.go(RoutesName.login),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  LocaleKeys.login.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ] else ...[
            if (email != null && email.isNotEmpty) ...[
              10.ph,
              _ContactLine(icon: Icons.mail_outline_rounded, text: email),
            ],
            if (phone != null && phone.isNotEmpty) ...[
              6.ph,
              _ContactLine(
                icon: Icons.phone_outlined,
                text: displayPhone(phone),
              ),
            ],
            18.ph,
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: OutlinedButton.icon(
                onPressed: () => context.push(RoutesName.personalInformation),
                icon: Icon(Icons.edit_outlined, size: 18.sp),
                label: Text(
                  LocaleKeys.edit_profile.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.06,
                  ),
                  side: BorderSide(
                    color: AppColors.primaryColor.withValues(alpha: 0.25),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p.characters.first.toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final size = 88.r;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final initials = _initials;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.accentGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: hasImage
            ? CustomCachedNetworkImage(
                imageUrl: imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: AppColors.accentGradient,
                ),
                child: initials.isEmpty
                    ? Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.whiteColor,
                        size: 40.r,
                      )
                    : Text(
                        initials,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
              ),
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: surface.textSecondary),
        6.pw,
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // Phone numbers and emails read left-to-right in both locales.
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 13.sp, color: surface.textSecondary),
          ),
        ),
      ],
    );
  }
}
