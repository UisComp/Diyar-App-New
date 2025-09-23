import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Assets.images.diyarNativeSplash.image(
                      height: 321.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    20.ph,
                    Text(
                      LocaleKeys.welcome_message.tr(),
                      style: AppStyle.fontSize22Bold,
                    ),
                    Text(
                      LocaleKeys.discover_message.tr(),
                      textAlign: TextAlign.center,
                      style: AppStyle.fontSize16Regular,
                    ).paddingAll(16.sp),
                    24.ph,
                    CustomButton(
                      buttonText: LocaleKeys.register.tr(),
                      buttonColor: AppColors.primaryColor,
                      onPressed: () {
                        context.push(RoutesName.register);
                      },
                    ).paddingSymmetric(horizontal: 16.sp),
                    12.ph,
                    CustomButton(
                      buttonText: LocaleKeys.login.tr(),
                      textColor: AppColors.blackColor,
                      buttonColor: AppColors.secondaryColor,
                      onPressed: () {
                        context.push(RoutesName.login);
                      },
                    ).paddingSymmetric(horizontal: 16.sp),
                  ],
                ),
              ),
            ),
            Text(
              LocaleKeys.by_continue.tr(),
              textAlign: TextAlign.center,
              style: AppStyle.fontSize16Regular.copyWith(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ).paddingAll(16.sp),
          ],
        ),
      ),
    );
  }
}
