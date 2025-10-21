import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/finance/view/widgets/balance_card.dart';
import 'package:diyar_app/feature/finance/view/widgets/receipts_and_due_payment.dart';
import 'package:diyar_app/feature/finance/view/widgets/transaction_item.dart';
import 'package:diyar_app/feature/finance/view/widgets/transactions_filter.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.finance.tr()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.ph,
            Text(
              LocaleKeys.account_statements.tr(),
              style: AppStyle.fontSize22Bold(context).copyWith(
                color: AppColors.primaryColor,
              ),
            ),
            20.ph,
           const BalanceCard(),
            15.ph,
            const ReceiptsAndDuePayment(),
            10.ph,
            const TransactionsFilter(),
            const TransactionItem(),
            10.ph,
            const TransactionItem(),
            10.ph,
            const TransactionItem(isReceived: false),
          ],
        ).paddingSymmetric(horizontal: 16.w),
      ),
    );
  }
}