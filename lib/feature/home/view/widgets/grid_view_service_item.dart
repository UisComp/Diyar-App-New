import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/enums/enum_service.dart';
import 'package:diyar_app/feature/home/model/user_services_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GridViewServiceItem extends StatelessWidget {
  const GridViewServiceItem({
    super.key,
    required this.cardColor,
    required this.cardImageColor,
    required this.textColor,
    required this.service,
    this.isFromViewAll = false,
  });
  final bool? isFromViewAll;
  final Color cardColor;
  final Color cardImageColor;
  final Color textColor;
  final UserServiceData? service;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (service?.isActive == true) {
          final serviceType = ServiceType.fromInt(service?.type);
          final screenName = getScreenNameByServiceType(serviceType);

          if (screenName != null) {
            if (service?.type == 5) {
              if (isFromViewAll == true) {
                context.push(screenName, extra: service);
              } else {
                context.read<HomeController>().changeIndexBottomNavBar(3);
              }
            } else {
              context.push(screenName, extra: service);
            }
          } else {
            AppFunctions.errorMessage(
              context,
              message: LocaleKeys.service_not_available.tr(),
            );
          }
        } else {
          AppFunctions.errorMessage(
            context,
            message: LocaleKeys.service_not_active.tr(),
          );
        }
      },
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cardImageColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                child: CustomCachedNetworkImage(
                  isProjectDetails: true,
                  fit: BoxFit.scaleDown,
                  height: 60.h,
                  width: 60.w,
                  imageUrl: service?.icon?.url,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  service?.name ?? 'Unknown',
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
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
  }
}
