import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/awaiting_plan_view.dart';
import 'package:diyar_app/feature/finance/view/widgets/next_payment_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/unit_financials_summary.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One unit on the finance overview. Tapping opens its payment plan.
class UnitFinanceCard extends StatelessWidget {
  const UnitFinanceCard({super.key, required this.unit, this.onTap});

  final FinanceUnit unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final financials = unit.financials;
    final hasPlan = unit.hasPaymentPlan && financials != null;
    final subtitle = [
      if (unit.project?.name?.isNotEmpty ?? false) unit.project!.name!,
      if (unit.building != null && unit.building!.type != BuildingType.unknown)
        unit.building!.type.labelKey.tr(),
    ].join('  •  ');

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: hasPlan ? onTap : null,
          child: Ink(
            padding: EdgeInsets.all(14.w),
            decoration: surface.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        width: 40.r,
                        height: 40.r,
                        child: unit.imageUrl != null
                            ? CustomCachedNetworkImage(
                                imageUrl: unit.imageUrl,
                                width: 40.r,
                                height: 40.r,
                                fit: BoxFit.cover,
                                // The card opens the payment plan, which
                                // shows the picture large and zoomable.
                                enablePreview: false,
                              )
                            : ColoredBox(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.10,
                                ),
                                child: Icon(
                                  Icons.apartment_rounded,
                                  color: AppColors.primaryColor,
                                  size: 22.sp,
                                ),
                              ),
                      ),
                    ),
                    10.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: surface.textPrimary,
                            ),
                          ),
                          if (subtitle.isNotEmpty)
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: surface.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (hasPlan)
                      Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.chevron_left_rounded
                            : Icons.chevron_right_rounded,
                        color: AppColors.primaryColor.withValues(alpha: 0.7),
                      ),
                  ],
                ),
                14.ph,
                if (!hasPlan)
                  const AwaitingPlanView(compact: true)
                else ...[
                  UnitFinancialsSummary(financials: financials),
                  if (financials.nextInstallment != null) ...[
                    12.ph,
                    NextPaymentCard(installment: financials.nextInstallment!),
                  ],
                  12.ph,
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      LocaleKeys.view_payment_plan.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
