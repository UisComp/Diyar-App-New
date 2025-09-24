
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiptsAndDuePayment extends StatelessWidget {
  const ReceiptsAndDuePayment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.receipts.tr(),
          style: AppStyle.fontSize22Bold.copyWith(
            color: AppColors.blackColor,
            fontSize: 14.sp,
          ),
        ),
        Text(
          LocaleKeys.due_payments.tr(),
          style: AppStyle.fontSize22Bold.copyWith(
            color: AppColors.blackColor,
            fontSize: 14.sp,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 16.w);
  }
}
