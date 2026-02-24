import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDirection? textDirection;
  final bool? softWrap;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
  });
  bool _isRtl(String text) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]+').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final detectedDirection =
        textDirection ?? (_isRtl(text) ? TextDirection.rtl : TextDirection.ltr);

    return Text(
      text,
      style:
          style ??
          AppStyle.fontSize14RegularNewsReader(
            context,
          ).copyWith(color: AppColors.greyColor),
      textAlign:
          textAlign ??
          (detectedDirection == TextDirection.rtl
              ? TextAlign.right
              : TextAlign.left),
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: detectedDirection,
    );
  }
}
