import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.project_details.tr()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.ph,
            InkWell(
              onTap: () {
                context.push(RoutesName.unitEvents);
              },
              child: Assets.images.projectDetails.image(
                width: double.infinity,
                fit: BoxFit.fill,
                height: 250.h,
              ),
            ),
            20.ph,
            Text(LocaleKeys.master_plan.tr(), style: AppStyle.fontSize22Bold),
            20.ph,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: .95,
              ),
              itemBuilder: (context, index) {
                return Card(
                  color: AppColors.whiteColor,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.r),
                              topLeft: Radius.circular(12.r),
                            ),
                          ),
                          child: Assets.images.diyarPmc.image(
                            width: 80.w,
                            height: 70.h,
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                );
              },
            ),
          ],
        ).paddingSymmetric(horizontal: 16.w),
      ),
    );
  }
}
