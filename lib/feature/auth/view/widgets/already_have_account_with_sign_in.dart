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

class AlreadyHaveAccountWithSignIn extends StatelessWidget {
  const AlreadyHaveAccountWithSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.already_have_account.tr(),
          style: AppStyle.fontSize16Regular.copyWith(
            fontSize: 14.sp,
            color: AppColors.primaryColor,
          ),
        ),
        5.pw,
        InkWell(
          onTap: () {
            context.push(RoutesName.login);
          },
          child: Text(
            LocaleKeys.sign_in.tr(),
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
