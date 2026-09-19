import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/documents/controller/documents_controller.dart';
import 'package:diyar_app/feature/documents/controller/documents_state.dart';
import 'package:diyar_app/feature/documents/model/documents_response_model.dart';
import 'package:diyar_app/feature/documents/view/widgets/document_group_card.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The customer's attachments (contract, payment plan, engineering drawings
/// and other files). Opened from the profile page.
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentsController()..getDocuments(),
      child: Scaffold(
        appBar: CustomAppBar(titleAppBar: LocaleKeys.my_documents.tr()),
        body: BlocConsumer<DocumentsController, DocumentsState>(
          listener: (context, state) {
            switch (state) {
              case PreviewFileFailureState(:final errorMessage):
                AppFunctions.errorMessage(
                  context,
                  message: errorMessage ?? LocaleKeys.error_preview_file.tr(),
                );
              case DownloadFileFailureState(:final errorMessage):
                AppFunctions.errorMessage(
                  context,
                  message:
                      errorMessage ?? LocaleKeys.error_downloading_file.tr(),
                );
              case DownloadFileSuccessState():
                AppFunctions.successMessage(
                  context,
                  message: LocaleKeys.download_file_successfully.tr(),
                );
              default:
                break;
            }
          },
          buildWhen: (previous, current) =>
              current is GetDocumentsLoadingState ||
              current is GetDocumentsSuccessState ||
              current is GetDocumentsFailureState,
          builder: (context, state) {
            final controller = DocumentsController.get(context);
            final isLoading =
                state is GetDocumentsLoadingState ||
                state is DocumentsInitialState;
            final docs = controller.documentsResponseModel.data;

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: controller.getDocuments,
              child: Skeletonizer(
                enabled: isLoading,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  children: [
                    DocumentGroupCard(
                      title: LocaleKeys.contract.tr(),
                      icon: Icons.description_outlined,
                      files: _single(docs?.contract, isLoading),
                    ),
                    DocumentGroupCard(
                      title: LocaleKeys.payment_plan.tr(),
                      icon: Icons.event_note_outlined,
                      files: _single(docs?.installmentsTable, isLoading),
                    ),
                    DocumentGroupCard(
                      title: LocaleKeys.engineering_structure.tr(),
                      icon: Icons.architecture_outlined,
                      files: _single(docs?.engineeringStructure, isLoading),
                    ),
                    DocumentGroupCard(
                      title: LocaleKeys.other_documents.tr(),
                      icon: Icons.folder_open_outlined,
                      files: isLoading
                          ? [_placeholderFile]
                          : docs?.otherDocuments ?? const [],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static final _placeholderFile = DocumentFile(
    name: 'Document placeholder.pdf',
    size: 204800,
    uploadedAt: '2026-01-01',
  );

  static List<DocumentFile> _single(DocumentFile? file, bool isLoading) {
    if (isLoading) return [_placeholderFile];
    return file == null ? const [] : [file];
  }
}
