import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.news.tr()),
      body: ListView.separated(
        separatorBuilder: (context, index) => 10.ph,
        itemCount: 10,
        itemBuilder: (context, index) => CustomContainerInformation(
          onTap: () {
            context.push(RoutesName.newsDetailsScreen);
          },
          descriptionContainer: "2 Days",
          titleContainer: "New Project Launch",
          svgIcon: Assets.images.svg.home,
        ),
      ),
    );
  }
}
