import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
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

          if (userModel?.data?.accessToken == null) {
            if (serviceType == ServiceType.type1 ||
                serviceType == ServiceType.type11 ||
                serviceType == ServiceType.type12) {
              if (screenName != null) {
                context.push(screenName, extra: service);
              }
            } else {
              AppFunctions.warningMessage(
                context,
                message: LocaleKeys.available_for_logged_in_users_only.tr(),
              );
            }
            return;
          }

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
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentHoverColor.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor.withValues(alpha: 0.06),
                      AppColors.accentHoverColor.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                child: CustomCachedNetworkImage(
                  isProjectDetails: true,
                  tintBrand: true,
                  fit: BoxFit.scaleDown,
                  height: 56.h,
                  width: 56.w,
                  imageUrl: service?.icon?.url,
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.primaryColor.withValues(alpha: 0.10),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: AppText(
                  context.locale.languageCode == AppConstants.enLanguage
                      ? service?.name ?? ''
                      : service?.nameAr ?? '',
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    color: textColor,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
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
