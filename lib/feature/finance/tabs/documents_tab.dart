import 'package:diyar_app/feature/finance/model/documents_response_model.dart';
import 'package:diyar_app/feature/finance/view/widgets/document_group_card.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DocumentsTab extends StatelessWidget {
  final DocumentsData? documentGroups;

  const DocumentsTab({super.key, required this.documentGroups});

  @override
  Widget build(BuildContext context) {
    final docs = documentGroups;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DocumentGroupCard(
            title: LocaleKeys.engineering_structure.tr(),
            files: docs?.engineeringStructure != null
                ? [docs!.engineeringStructure!]
                : [],
          ),
          DocumentGroupCard(
            title: LocaleKeys.contract.tr(),
            files: docs?.contract != null ? [docs!.contract!] : [],
          ),
          DocumentGroupCard(
            title: LocaleKeys.installments_table.tr(),
            files: docs?.installmentsTable != null
                ? [docs!.installmentsTable!]
                : [],
          ),
          DocumentGroupCard(
            title: LocaleKeys.other_documents.tr(),
            files: docs?.otherDocuments ?? [],
          ),
        ],
      ),
    );
  }
}
