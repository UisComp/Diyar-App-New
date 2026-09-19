import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/feature/documents/controller/documents_controller.dart';
import 'package:diyar_app/feature/documents/controller/documents_state.dart';
import 'package:diyar_app/feature/documents/model/documents_response_model.dart';
import 'package:diyar_app/feature/documents/view/documents_screen.dart';
import 'package:diyar_app/feature/documents/view/widgets/document_group_card.dart';
import 'package:diyar_app/feature/documents/view/widgets/file_card.dart';
import 'package:diyar_app/feature/profile/view/widgets/profile_documents_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('profile tile opens the documents screen', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) =>
              const Scaffold(body: Center(child: ProfileDocumentsTile())),
        ),
        GoRoute(
          path: RoutesName.documentsScreen,
          builder: (_, _) => const Scaffold(body: Text('documents-route')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await pumpLocalizedRouter(tester, router);

    expect(find.text('My documents'), findsOneWidget);
    expect(
      find.text('Contract, payment plan, engineering drawings and more'),
      findsOneWidget,
    );

    await tester.tap(find.byType(ProfileDocumentsTile));
    await tester.pumpAndSettle();

    expect(find.text('documents-route'), findsOneWidget);
  });

  testWidgets('profile tile is translated to Arabic', (tester) async {
    await pumpLocalized(
      tester,
      const ProfileDocumentsTile(),
      locale: const Locale('ar'),
    );
    expect(find.text('مستنداتي'), findsOneWidget);
  });

  group('DocumentGroupCard', () {
    Widget wrap(Widget child) => BlocProvider(
      create: (_) => DocumentsController(),
      child: SingleChildScrollView(child: child),
    );

    testWidgets('shows an empty state without files', (tester) async {
      await pumpLocalized(
        tester,
        wrap(
          const DocumentGroupCard(
            title: 'Contract',
            icon: Icons.description_outlined,
            files: [],
          ),
        ),
      );
      expect(find.text('No Documents Found'), findsOneWidget);
      expect(find.byType(FileCard), findsNothing);
    });

    testWidgets('lists files with date, size and actions', (tester) async {
      await pumpLocalized(
        tester,
        wrap(
          DocumentGroupCard(
            title: 'Other Documents',
            icon: Icons.folder_open_outlined,
            files: [
              DocumentFile(
                name: 'Contract.pdf',
                url: 'https://example.com/contract.pdf',
                size: 2 * 1024 * 1024,
                uploadedAt: '2026-09-01T10:00:00Z',
              ),
              DocumentFile(
                name: 'Plan.png',
                url: 'https://example.com/plan.png',
                size: 512,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(FileCard), findsNWidgets(2));
      expect(find.text('2'), findsOneWidget); // count badge
      expect(find.text('Contract.pdf'), findsOneWidget);
      expect(find.text('2026-09-01  •  2.0 MB'), findsOneWidget);
      expect(find.text('512 B'), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
      expect(find.byIcon(Icons.download_rounded), findsNWidgets(2));
    });
  });

  testWidgets('documents screen shows all groups after loading', (
    tester,
  ) async {
    // No API client in tests, so loading ends in a failure with no files.
    await pumpLocalized(tester, const DocumentsScreen(), wrapInScaffold: false);

    expect(find.text('My documents'), findsOneWidget);
    expect(find.text('Contract'), findsOneWidget);
    expect(find.text('Payment Plan'), findsOneWidget);
    expect(find.text('Engineering Structure'), findsOneWidget);
    expect(find.text('Other Documents'), findsOneWidget);
    expect(find.text('No Documents Found'), findsNWidgets(4));
  });

  test(
    'DocumentsController reports a failure when the request fails',
    () async {
      final controller = DocumentsController();
      addTearDown(controller.close);

      await controller.getDocuments();

      expect(controller.state, isA<GetDocumentsFailureState>());
    },
  );

  test('file sizes are human readable', () {
    expect(FileCard.formatFileSize(900), '900 B');
    expect(FileCard.formatFileSize(1536), '1.5 KB');
    expect(FileCard.formatFileSize(3 * 1024 * 1024), '3.0 MB');
  });
}
