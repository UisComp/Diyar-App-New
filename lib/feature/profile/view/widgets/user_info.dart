import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.profile});

  final ProfileData? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          profile?.name ?? 'Guest',
          style: AppStyle.fontSize22Bold(context),
          textAlign: TextAlign.center,
        ),
        5.ph,
        Text(
          profile?.email ?? '',
          style: AppStyle.fontSize16Regular(
            context,
          ).copyWith(color: AppColors.descContainerColor),
          textAlign: TextAlign.center,
        ),
        5.ph,
        Text(
          profile?.phoneNumber ?? '',
          style: AppStyle.fontSize16Regular(
            context,
          ).copyWith(color: AppColors.descContainerColor),
          textAlign: TextAlign.center,
        ),
        20.ph,
        Align(
          alignment: context.locale.languageCode == AppConstants.enLanguage
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Text(
            LocaleKeys.linked_units.tr(),
            style: AppStyle.fontSize22Bold(context).copyWith(fontSize: 18.sp),
          ),
        ),
      ],
    );
  }
}
