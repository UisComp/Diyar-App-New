
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionsFilter extends StatelessWidget {
  const TransactionsFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.transactions.tr(),
          style: AppStyle.fontSize22Bold.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            size: 40.sp,
            Icons.filter_list_alt,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 16.w);
  }
}
