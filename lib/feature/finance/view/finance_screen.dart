import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/tabs/documents_tab.dart';
import 'package:diyar_app/feature/finance/tabs/finance_tab.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = userModel?.data?.accessToken == null;

    if (isGuest) {
      return Scaffold(
        appBar: CustomAppBar(titleAppBar: LocaleKeys.finance.tr()),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                40.ph,
                CustomButton(
                  buttonColor: AppColors.primaryColor,
                  buttonText: LocaleKeys.login.tr(),
                  onPressed: () {
                    context.go(RoutesName.login);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => FinanceController()
        ..getFinance()
        ..getDocumets(),
      child: BlocBuilder<LanguageController, LanguageState>(
        buildWhen: (previous, current) => current is ChangeCurrentLanguageState,
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(titleAppBar: LocaleKeys.finance.tr()),
            body: BlocConsumer<FinanceController, FinanceState>(
              listener: (context, state) {
                state.whenOrNull(
                  previewFileFailure: (errorMessage) {
                    AppFunctions.errorMessage(
                      context,
                      message:
                          errorMessage ?? LocaleKeys.error_preview_file.tr(),
                    );
                  },
                  downloadFileFailure: (errorMessage) {
                    AppFunctions.errorMessage(
                      context,
                      message:
                          errorMessage ??
                          LocaleKeys.error_downloading_file.tr(),
                    );
                  },
                  downloadFileSuccess: () {
                    AppFunctions.successMessage(
                      context,
                      message: LocaleKeys.download_file_successfully.tr(),
                    );
                  },
                );
              },
              builder: (context, state) {
                return Column(
                  children: [
                    10.ph,
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryColor,
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: AppColors.greyColor,
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
                          FinanceTab(
                            onRefresh: () async {
                              await FinanceController.get(context).getFinance();
                            },
                          ),
                          DocumentsTab(
                            onRefresh: () async {
                              await FinanceController.get(
                                context,
                              ).getDocumets();
                            },
                            documentGroups: FinanceController.get(
                              context,
                            ).documentsResponseModel.data,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
