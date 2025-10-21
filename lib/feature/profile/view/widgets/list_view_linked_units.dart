
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListViewLinkedUnits extends StatelessWidget {
  const ListViewLinkedUnits({
    super.key,
    required this.linkedUnits,
  });

  final List<UserUnit> linkedUnits;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: linkedUnits.length,
        itemBuilder: (context, index) {
          final unit = linkedUnits[index];
          return CustomContainerInformation(
            width: 50.w,
            height: 50.h,
            titleContainer: unit.name ?? '',
            descriptionContainer: "",
            imageUrl: unit.imageUrl?.url,
          ).paddingOnly(bottom: 10.h);
        },
      );
  }
}
