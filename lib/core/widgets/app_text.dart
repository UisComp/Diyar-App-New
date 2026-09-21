import 'package:diyar_app/core/helper/text_direction_helper.dart';
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
  @override
  Widget build(BuildContext context) {
    // Content (a news title, a name) reads in its own language's direction,
    // whatever the app's language is.
    final detectedDirection =
        textDirection ?? TextDirectionHelper.resolve(context, text);

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
