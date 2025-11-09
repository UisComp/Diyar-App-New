import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/finance/controller/finance_controller.dart';
import 'package:diyar_app/feature/finance/controller/finance_state.dart';
import 'package:diyar_app/feature/finance/model/documents_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/empty_dotted_box.dart';
import 'package:diyar_app/feature/finance/view/widgets/file_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DocumentGroupCard extends StatelessWidget {
  final String title;
  final List<DocumentFile> files;

  const DocumentGroupCard({
    super.key,
    required this.title,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceController, FinanceState>(
      builder: (context, state) {
        final bool isLoading = state.maybeWhen(
          getDocumentsLoading: () => true,
          orElse: () => false,
        );

        return Skeletonizer(
          enabled: isLoading,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.fontSize18Bold(context)
                      .copyWith(color: AppColors.primaryColor),
                ),
                10.ph,
                if (files.isEmpty)
                  const EmptyDottedBox()
                else
                  Column(
                    children: List.generate(
                      files.length,
                      (i) => FileCard(file: files[i]),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
