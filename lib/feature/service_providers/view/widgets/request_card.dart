import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/service_providers/model/service_provider_history_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestCard extends StatelessWidget {
  final ServiceProviderBookingModel request;
  final bool isDark;
  final VoidCallback onTap;

  const RequestCard({
    super.key,
    required this.request,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(request.status);
    final serviceProvider = request.serviceProvider;

    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CustomCachedNetworkImage(
                      imageUrl: serviceProvider?.iconUrl ?? "",
                      width: 80.w,
                      height: 80.h,
                    ),
                  ),
                ),
                16.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        serviceProvider?.jobTitle ?? "",
                        style: AppStyle.fontSize16Bold(context).copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.ph,
                      if (request.bookingDate != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                            6.pw,
                            Expanded(
                              child: AppText(
                                AppFormatter.formatDate(
                                  DateTime.parse(
                                    request.bookingDate!,
                                  ).toUtc().toLocal(),
                                ),
                                style: AppStyle.fontSize12Regular(
                                  context,
                                ).copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                        4.ph,
                      ],
                      Row(
                        children: [
                          Icon(
                            getStatusIcon(request.status),
                            size: 16.sp,
                            color: statusColor,
                          ),
                          6.pw,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: AppText(
                              getTranslatedStatus(request.status),
                              style: AppStyle.fontSize12Bold(
                                context,
                              ).copyWith(color: statusColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
