
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyNews extends StatelessWidget {
  const EmptyNews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.no_news_found.tr(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
