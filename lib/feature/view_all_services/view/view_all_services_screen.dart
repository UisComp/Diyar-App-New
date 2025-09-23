import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ViewAllServicesScreen extends StatelessWidget {
  final List<String> services;

  const ViewAllServicesScreen({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.diyar.tr(),
        showIconNotification: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomTextFormField(
                  hintStyle: AppStyle.fontSize16Regular.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  hintText: LocaleKeys.search_services.tr(),
                  prefixIcon: SvgPicture.asset(
                    Assets.images.svg.search,
                    height: 24.h,
                    width: 24.w,
                    fit: BoxFit.scaleDown,
                  ),
                ).paddingOnly(top: 47.h),
                24.ph,
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.sp),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 149.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Assets.images.diyarPmc.image(
                        width: 80.w,
                        height: 70.h,
                      ),
                    ),
                    8.ph,
                    Text(
                      services[index],
                      style: AppStyle.fontSize16Regular.copyWith(
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }, childCount: services.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
