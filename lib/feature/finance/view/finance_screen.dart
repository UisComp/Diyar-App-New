import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/tabs/documents_tab.dart';
import 'package:diyar_app/feature/finance/tabs/finance_tab.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> units = ["الوحدة رقم 1", "الوحدة رقم 2"];

  final List<Map<String, dynamic>> documentGroups = [
    {
      "title": "المرفق الهندسى",
      "files": [
        {
          "name": "عقد شراء الوحدة.pdf",
          "url":
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
          "date": "2025-05-15",
          "size": "1.2 MB",
        },
      ],
    },
     {
      "title": "العقد",
      "files": [
        {
          "name": "عقد شراء الوحدة.pdf",
          "url":
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
          "date": "2025-05-15",
          "size": "1.2 MB",
        },
      ],
    },
    {
      "title": "جدول الأقساط",
      "files": [
        {
          "name": "عقد شراء الوحدة.pdf",
          "url":
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
          "date": "2025-05-15",
          "size": "1.2 MB",
        },
      ],
    },
    {"title": "ملفات أخرى", "files": []},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.finance.tr()),
      body: BlocConsumer<FinanceController, FinanceState>(
        listener: (context, financeState) {
          if (financeState is PriviewFileFailureState) {
            AppFunctions.errorMessage(
              context,
              message:
                  financeState.errorMessage ??
                  LocaleKeys.error_preview_file.tr(),
            );
          }
          if (financeState is DownloadFileFailureState) {
            AppFunctions.errorMessage(
              context,
              message:
                  financeState.errorMessage ??
                  LocaleKeys.error_downloading_file.tr(),
            );
          }
           if (financeState is DownloadFileSuccessState) {
            AppFunctions.successMessage(
              context,
              message:
                  LocaleKeys.download_file_successfully.tr()
            );
          }
          
        },
        builder: (context, financeState) {
          return Column(
            children: [
              10.ph,
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryColor,
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: AppStyle.fontSize16Regular(context),
                tabs: [
                  Tab(text: LocaleKeys.finance.tr()),
                  Tab(text: LocaleKeys.documents.tr()),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FinanceTab(units: units),
                    DocumentsTab(documentGroups: documentGroups),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}