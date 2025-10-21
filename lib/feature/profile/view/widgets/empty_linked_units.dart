
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyLinkedUnits extends StatelessWidget {
  const EmptyLinkedUnits({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          LocaleKeys.no_new_unit_available.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
  }
}
