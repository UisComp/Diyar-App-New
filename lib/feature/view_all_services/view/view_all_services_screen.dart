import 'package:diyar_app/core/constants/app_constants.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ViewAllServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services;

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
                return InkWell(
                  onTap: () {
                    final service = services[index];
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
                              services[index]["image"],
                              fit: BoxFit.cover,
                              width: 80.w,
                              height: 70.h,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              services[index]['name'],
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
