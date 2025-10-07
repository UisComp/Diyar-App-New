import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';

class CustomAppPrefText extends StatelessWidget {
  const CustomAppPrefText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.fontSize22Bold(context));
  }
}
