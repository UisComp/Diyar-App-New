import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/view_all_services/view/view_all_services_screen.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final limitedServices = services.take(5).toList();

    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.diyar.tr(),
        showIconNotification: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //! Search
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
            30.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.services.tr(),
                  style: AppStyle.fontSize22Bold.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ViewAllServicesScreen(services: services),
                      ),
                    );
                  },
                  child: Text(
                    LocaleKeys.view_all.tr(),
                    style: AppStyle.fontSize16Regular.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 22.sp),
            20.ph,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: limitedServices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: .95,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    final service = limitedServices[index];
                    final type = service["type"] as int?;
                    final screenName = getScreenNameByType(type);

                    if (screenName != null) {
                      context.push(screenName, extra: service);
                    } else {
                      Fluttertoast.showToast(
                        msg: "This service is not available yet",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: AppColors.redColor,
                        textColor: Colors.white,
                      );
                    }
                  },
                  child: Card(
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
                            child: Image.asset(
                              limitedServices[index]['image'],
                              width: 80.w,
                              height: 70.h,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              limitedServices[index]['name'],
                              style: AppStyle.fontSize16Regular.copyWith(
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 20.sp),
          ],
        ),
      ),
    );
  }
}
