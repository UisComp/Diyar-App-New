import 'package:diyar_app/feature/finance/view/widgets/document_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentsTab extends StatelessWidget {
  final List<Map<String, dynamic>> documentGroups;
  const DocumentsTab({super.key, required this.documentGroups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: documentGroups.length,
      itemBuilder: (context, index) {
        final group = documentGroups[index];
        return DocumentGroupCard(group: group);
      },
    );
  }
}