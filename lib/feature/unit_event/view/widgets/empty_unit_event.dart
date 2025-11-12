import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyUnitEvent extends StatelessWidget {
  const EmptyUnitEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(Assets.images.emptyRealState),
          Text(
            LocaleKeys.no_events_found.tr(),
            style: AppStyle.fontSize18Bold(context),
          ),
        ],
      ),
    );
  }
}
