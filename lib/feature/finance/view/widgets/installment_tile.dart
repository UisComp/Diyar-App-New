import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/feature/finance/view/widgets/installment_payments_sheet.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One row of the payment schedule. Tapping shows the payments behind it.
class InstallmentTile extends StatelessWidget {
  const InstallmentTile({
    super.key,
    required this.installment,
    this.highlighted = false,
  });

  final Installment installment;

  /// Emphasised when opened from a payment/overdue notification.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final status = installment.displayStatus;
    final statusColor = FinanceColors.forStatus(status);
    final isPaid = status == InstallmentStatus.paid;
    final showProgress =
        !isPaid && installment.paidAmount > 0 && installment.amount > 0;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () => InstallmentPaymentsSheet.show(context, installment),
          child: Ink(
            decoration: surface.cardDecoration(
              radius: 14.r,
              borderColor: highlighted ? AppColors.primaryColor : null,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadiusDirectional.horizontal(
                        start: Radius.circular(14.r),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _NumberBadge(number: installment.number),
                              10.pw,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      installment.type.labelKey.tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: surface.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      FinanceFormatter.date(
                                        context,
                                        installment.dueDate,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: surface.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InstallmentStatusChip(status: status),
                            ],
                          ),
                          10.ph,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  FinanceFormatter.dueLabel(
                                    context,
                                    installment,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: status == InstallmentStatus.overdue
                                        ? FinanceColors.overdue
                                        : surface.textSecondary,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!isPaid)
                                    Text(
                                      LocaleKeys.remaining.tr(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: surface.textSecondary,
                                      ),
                                    ),
                                  Text(
                                    FinanceFormatter.money(
                                      isPaid
                                          ? installment.amount
                                          : installment.remainingAmount,
                                    ),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: isPaid
                                          ? FinanceColors.paid
                                          : surface.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (showProgress) ...[
                            10.ph,
                            FinanceProgressBar(
                              value: installment.paidFraction,
                              color: statusColor,
                              height: 5.h,
                            ),
                            4.ph,
                            Text(
                              LocaleKeys.amount_paid_of.tr(
                                args: [
                                  FinanceFormatter.amount(
                                    installment.paidAmount,
                                  ),
                                  FinanceFormatter.money(installment.amount),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: surface.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});

  final int? number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        number?.toString() ?? '-',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
