import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomServiceAndViewAllTexts extends StatelessWidget {
  const CustomServiceAndViewAllTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.services.tr(),
          style: AppStyle.fontSize22Bold(context).copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),
       
          InkWell(
            onTap: () {
              context.push(RoutesName.viewAllServicesScreen);
            },
            child: Text(
              LocaleKeys.view_all.tr(),
              style: AppStyle.fontSize16Regular(context),
            ),
          ),
      ],
    ).paddingSymmetric(horizontal: 22.sp);
  }
}
