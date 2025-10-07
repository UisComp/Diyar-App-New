
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppStyle.fontSize22BoldNewsReader(context),
    ).paddingSymmetric(horizontal: 16.w);
  }
}
