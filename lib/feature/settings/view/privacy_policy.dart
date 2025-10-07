import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
        titleAppBar: LocaleKeys.privacy_settings.tr(),
      ),
      body: SingleChildScrollView(
        child: Text(
          textAlign: TextAlign.center,
          LocaleKeys.privacy_policy.tr(),style: AppStyle.fontSize14RegularNewsReader(context)
        //   .copyWith(
        //   fontSize: 16.sp,
        //   fontWeight: FontWeight.w400,
        //   height: 1.5.h,
        // )
        ,).paddingSymmetric(horizontal: 16.w),
      ),
    );
  }
}