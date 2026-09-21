import 'dart:async';

import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/unit_image_gallery.dart';
import 'package:diyar_app/core/widgets/zoomable_image_viewer.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart';
import 'package:diyar_app/feature/profile/model/unit_model_details_for_linked_user.dart'
    show UnitModelDetailsForLinkedUserResponseModel;
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

Map<String, dynamic> _image(String url) => {
  'id': 1,
  'url': url,
  'file_name': 'u.jpg',
  'mime_type': 'image/jpeg',
};

const _main = 'https://x/unit-main.jpg';
const _plan = 'https://x/unit-plan.jpg';

void main() {
  group('a unit carries its pictures', () {
    test('UnitSummary reads main_image and the media gallery', () {
      final unit = UnitSummary.fromJson({
        'id': 412,
        'code': 'T1-G',
        'label': 'Town 1 · T-1-G',
        'main_image': _image(_main),
        'media': [_image(_plan)],
      });

      expect(unit.imageUrl, _main);
      expect(unit.gallery, [_plan]);
      expect(unit.images, [_main, _plan]);
    });

    test('UnitSummary without pictures is empty, not broken', () {
      final unit = UnitSummary.fromJson({
        'id': 1,
        'code': 'V-1',
        'main_image': null,
        'media': null,
      });

      expect(unit.imageUrl, isNull);
      expect(unit.images, isEmpty);
    });

    test('media entries without a url are skipped', () {
      final unit = UnitSummary.fromJson({
        'id': 1,
        'code': 'V-1',
        'media': [
          {'id': 9},
          _image(_plan),
          'not a map',
        ],
      });

      expect(unit.images, [_plan]);
    });

    test('GET /api/units/{id} carries main_image then media', () {
      final model = UnitModelDetailsForLinkedUserResponseModel.fromJson({
        'success': true,
        'data': {
          'id': 412,
          'code': 'T1-G',
          'main_image': _image(_main),
          'media': [_image(_plan)],
        },
      });

      expect(model.data!.images, [_main, _plan]);
    });

    test('GET /api/units carries them too, for the list row', () {
      final unit = UserUnit.fromJson({
        'id': 412,
        'code': 'T1-G',
        'label': 'Town 1 · T-1-G',
        'main_image': _image(_main),
        'media': [_image(_plan)],
      });

      expect(unit.imageUrl?.url, _main);
      expect(unit.images, [_main, _plan]);
    });

    test('a finance unit shows its picture when the payload has one', () {
      final unit = FinanceUnit.fromJson({
        'unit_id': 412,
        'unit_code': 'T1-G',
        'main_image': _image(_main),
        'media': [_image(_plan)],
      });

      expect(unit.imageUrl, _main);
      expect(unit.images, [_main, _plan]);
    });

    test('a finance unit without pictures keeps the icon', () {
      final unit = FinanceUnit.fromJson({'unit_id': 412, 'unit_code': 'T1-G'});

      expect(unit.imageUrl, isNull);
      expect(unit.images, isEmpty);
    });
  });

  group('UnitImageGallery', () {
    testWidgets('no pictures: a placeholder, never a blank gap', (tester) async {
      await pumpLocalized(
        tester,
        const UnitImageGallery(images: [], title: 'Town 1'),
      );

      expect(find.text('No image found'), findsOneWidget);
      expect(find.byType(CustomCachedNetworkImage), findsNothing);
    });

    testWidgets('showWhenEmpty: false hides it entirely', (tester) async {
      await pumpLocalized(
        tester,
        const UnitImageGallery(images: [], showWhenEmpty: false),
      );

      expect(find.text('No image found'), findsNothing);
    });

    testWidgets('one picture: no thumbnail strip', (tester) async {
      await pumpLocalized(
        tester,
        const UnitImageGallery(images: [_main], title: 'Town 1'),
        settle: false,
      );

      expect(find.byType(CustomCachedNetworkImage), findsOneWidget);
      expect(find.text('Tap a photo to open it full screen and zoom'),
          findsOneWidget);
    });

    testWidgets('several pictures: main image plus a thumbnail each', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        const UnitImageGallery(images: [_main, _plan], title: 'Town 1'),
        settle: false,
      );

      // The big one, then one thumbnail per picture.
      expect(find.byType(CustomCachedNetworkImage), findsNWidgets(3));
      expect(find.text('2'), findsOneWidget);
    });
  });

  group('the full-screen viewer', () {
    testWidgets('tapping a unit picture opens it zoomable', (tester) async {
      await pumpLocalized(
        tester,
        const UnitImageGallery(images: [_main, _plan], title: 'Town 1'),
        settle: false,
      );

      await tester.tap(find.byType(CustomCachedNetworkImage).first);
      await pumpFrames(tester);

      expect(find.byType(ZoomableImageViewer), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsWidgets);
      // Page 1 of 2, and the unit's name as the caption.
      expect(find.text('1 / 2'), findsOneWidget);
      expect(find.text('Town 1'), findsOneWidget);
    });

    testWidgets('a thumbnail opens the viewer at its own picture', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        const UnitImageGallery(images: [_main, _plan], title: 'Town 1'),
        settle: false,
      );

      // The last CustomCachedNetworkImage is the second thumbnail.
      await tester.tap(find.byType(CustomCachedNetworkImage).last);
      await pumpFrames(tester);

      expect(find.text('2 / 2'), findsOneWidget);
    });

    testWidgets('enablePreview: false leaves the tap to the row', (
      tester,
    ) async {
      var rowTaps = 0;
      await pumpLocalized(
        tester,
        GestureDetector(
          // As InkWell does in the real rows.
          behavior: HitTestBehavior.opaque,
          onTap: () => rowTaps++,
          child: const CustomCachedNetworkImage(
            imageUrl: _main,
            width: 52,
            height: 52,
            enablePreview: false,
          ),
        ),
        settle: false,
      );

      // While the picture is still loading its skeleton ignores pointers,
      // exactly as in the app; the row's opaque hit test still takes the tap.
      await tester.tap(
        find.byType(CustomCachedNetworkImage),
        warnIfMissed: false,
      );
      await pumpFrames(tester);

      expect(rowTaps, 1);
      expect(find.byType(ZoomableImageViewer), findsNothing);
    });

    testWidgets('blank and duplicate urls never open an empty viewer', (
      tester,
    ) async {
      late BuildContext ctx;
      await pumpLocalized(
        tester,
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox.shrink();
          },
        ),
      );

      unawaited(openImageViewer(ctx, images: const [null, '', '   ']));
      await pumpFrames(tester);
      expect(find.byType(ZoomableImageViewer), findsNothing);

      unawaited(openImageViewer(ctx, images: const [_main, _main, '']));
      await pumpFrames(tester);
      expect(find.byType(ZoomableImageViewer), findsOneWidget);
      // The duplicate is dropped, so there is no counter at all.
      expect(find.textContaining(' / '), findsNothing);
    });
  });
}
