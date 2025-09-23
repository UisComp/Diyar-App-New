import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DontHaveAccountWithSignUp extends StatelessWidget {
  const DontHaveAccountWithSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.donnot_have_account.tr(),
          style: AppStyle.fontSize16Regular.copyWith(
            fontSize: 14.sp,
            color: AppColors.primaryColor,
          ),
        ),
        5.pw,
        InkWell(
          onTap: () {
            context.push(RoutesName.register);
          },
          child: Text(
            LocaleKeys.sign_up.tr(),
            style: AppStyle.fontSize16Regular.copyWith(
              fontSize: 14.sp,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 20.h);
  }
}
