import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstallmentsTable extends StatelessWidget {
  const InstallmentsTable({super.key});

  Color statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "paid":
        return AppColors.greenColor;
      case "overdue":
        return AppColors.redColor;
      case "pending":
        return AppColors.orangeColor;
      default:
        return AppColors.greyColor;
    }
  }

  String localizedStatus(String? status) {
    switch (status?.toLowerCase()) {
      case "paid":
        return LocaleKeys.paid.tr();
      case "overdue":
        return LocaleKeys.overdue.tr();
      case "pending":
        return LocaleKeys.pending.tr();
      default:
        return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceController, FinanceState>(
      builder: (context, state) {
        final units =
            FinanceController.get(context).financeResponseModel.data?.units ??
            [];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppColors.primaryColor.withOpacity(0.7),
            ),
            border: TableBorder.all(color: Colors.grey.shade300),
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    LocaleKeys.installment_number.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    LocaleKeys.date.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    LocaleKeys.amount.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    LocaleKeys.status.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: units.expand((unit) {
              final installments = unit.installments ?? [];
              return installments.map((installment) {
                final status = installment.status ?? "-";
                return DataRow(
                  cells: [
                    DataCell(
                      Center(
                        child: Text(installment.number?.toString() ?? '-'),
                      ),
                    ),
                    DataCell(Center(child: Text(installment.dueDate ?? '-'))),
                    DataCell(
                      Center(
                        child: Text(installment.amount?.toString() ?? '-'),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(status).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            localizedStatus(status),
                            style: TextStyle(
                              color: statusColor(status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
            }).toList(),
          ),
        );
      },
    );
  }
}
