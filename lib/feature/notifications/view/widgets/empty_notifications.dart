
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(LocaleKeys.no_notifications_found.tr()));
  }
}
