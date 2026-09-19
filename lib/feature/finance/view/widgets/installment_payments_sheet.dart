import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/finance/helper/finance_formatter.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/finance_common_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom sheet with a row's details and the payments recorded against it.
class InstallmentPaymentsSheet extends StatelessWidget {
  const InstallmentPaymentsSheet({super.key, required this.installment});

  final Installment installment;

  static Future<void> show(BuildContext context, Installment installment) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppSurface.of(context).card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => InstallmentPaymentsSheet(installment: installment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final status = installment.displayStatus;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: surface.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            16.ph,
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${installment.type.labelKey.tr()} #${installment.number ?? '-'}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: surface.textPrimary,
                    ),
                  ),
                ),
                InstallmentStatusChip(status: status),
              ],
            ),
            4.ph,
            Text(
              FinanceFormatter.dueLabel(context, installment),
              style: TextStyle(
                fontSize: 13.sp,
                color: status == InstallmentStatus.overdue
                    ? FinanceColors.overdue
                    : surface.textSecondary,
              ),
            ),
            16.ph,
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: surface.subtle,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: LocaleKeys.due_date.tr(),
                    value: FinanceFormatter.date(context, installment.dueDate),
                  ),
                  _DetailRow(
                    label: LocaleKeys.amount.tr(),
                    value: FinanceFormatter.money(installment.amount),
                  ),
                  _DetailRow(
                    label: LocaleKeys.paid.tr(),
                    value: FinanceFormatter.money(installment.paidAmount),
                    valueColor: FinanceColors.paid,
                  ),
                  _DetailRow(
                    label: LocaleKeys.remaining.tr(),
                    value: FinanceFormatter.money(installment.remainingAmount),
                    valueColor: status == InstallmentStatus.overdue
                        ? FinanceColors.overdue
                        : null,
                    isLast: true,
                  ),
                ],
              ),
            ),
            20.ph,
            Text(
              LocaleKeys.payments.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: surface.textPrimary,
              ),
            ),
            10.ph,
            if (installment.payments.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: surface.border),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  LocaleKeys.no_payments_yet.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: surface.textSecondary,
                  ),
                ),
              )
            else
              ...installment.payments.map(
                (payment) => _PaymentTile(payment: payment),
              ),
            16.ph,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16.sp,
                  color: surface.textSecondary,
                ),
                6.pw,
                Expanded(
                  child: Text(
                    LocaleKeys.payments_recorded_by_staff.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: surface.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: surface.textSecondary),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? surface.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment});

  final InstallmentPayment payment;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: surface.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: FinanceColors.paid.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 20.sp,
              color: FinanceColors.paid,
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FinanceFormatter.money(payment.amount),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: surface.textPrimary,
                  ),
                ),
                2.ph,
                Text(
                  '${FinanceFormatter.date(context, payment.paidAt)}  •  ${payment.method.labelKey.tr()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: surface.textSecondary,
                  ),
                ),
                if (payment.receiptNo?.isNotEmpty ?? false) ...[
                  2.ph,
                  Text(
                    '${LocaleKeys.receipt_no.tr()} ${payment.receiptNo}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
