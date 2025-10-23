
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InstallmentsTable extends StatelessWidget {
  const InstallmentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "رقم القسط": "1",
        "التاريخ": "2025-01-01",
        "المبلغ": "105,000 جنيه",
        "الحالة": "مدفوع",
        "إجراء": "عرض",
      },
      {
        "رقم القسط": "2",
        "التاريخ": "2025-02-01",
        "المبلغ": "105,000 جنيه",
        "الحالة": "قيد الانتظار",
        "إجراء": "دفع",
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            WidgetStateProperty.all(AppColors.primaryColor.withOpacity(0.1)),
        border: TableBorder.all(color: Colors.grey.shade300),
        columns: [
          DataColumn(label: Text(LocaleKeys.installment_number.tr())),
          DataColumn(label: Text(LocaleKeys.date.tr())),
          DataColumn(label: Text(LocaleKeys.amount.tr())),
          DataColumn(label: Text(LocaleKeys.status.tr())),
          DataColumn(label: Text(LocaleKeys.action.tr())),
        ],
        rows: data.map((row) {
          return DataRow(
            cells: [
              DataCell(Text(row["رقم القسط"]!)),
              DataCell(Text(row["التاريخ"]!)),
              DataCell(Text(row["المبلغ"]!)),
              DataCell(Text(row["الحالة"]!)),
              DataCell(
                InkWell(
                  onTap: null,
                  child: Text(
                    row["إجراء"]!,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

