import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.profile.tr()),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            
            children: [
              37.ph,
              CircleAvatar(
                radius: 50.r,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(Assets.images.svg.person),
                ),
              ),
              Text("Eyad Mohamed", style: AppStyle.fontSize22Bold),
              5.ph,
              Text(
                "eyadmohamed@gmail.com",
                style: AppStyle.fontSize16Regular.copyWith(
                  color: AppColors.descContainerColor,
                ),
              ),
              5.ph,
              Text(
                "+201010076119",
                style: AppStyle.fontSize16Regular.copyWith(
                  color: AppColors.descContainerColor,
                ),
              ),
              32.ph,
              Align(
                 alignment: Alignment.centerLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  "Linked Units",
                  style: AppStyle.fontSize22Bold.copyWith(fontSize: 18.sp),
                ),
              ).paddingSymmetric(horizontal: 16.w),
                8.ph,
              CustomContainerInformation(
                titleContainer: 'Diyar Residence',
                descriptionContainer: "Apartment 101, Building A",
                svgIcon: Assets.images.svg.home,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
