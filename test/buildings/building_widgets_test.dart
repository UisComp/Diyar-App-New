import 'package:diyar_app/core/constants/app_variable.dart';
import 'package:diyar_app/core/formatter/unit_code.dart';
import 'package:diyar_app/feature/profile/view/widgets/unit_info_card.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/project/view/project_details.dart';
import 'package:diyar_app/feature/project/view/widgets/building_units_sheet.dart';
import 'package:diyar_app/feature/project/view/widgets/master_plan_map.dart';
import 'package:diyar_app/feature/project/view/widgets/my_units_overview.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_test_env.dart' show signIn;
import '../helpers/test_app.dart';

/// A unit the signed-in user owns, as `GET /api/projects/{id}` sends it.
Map<String, dynamic> _owned({
  required int id,
  required String code,
  required int? floor,
  required Map<String, dynamic> building,
  num? unitValue = 4500000,
}) => {
  'id': id,
  'code': code,
  'name': null,
  'label': '${building['label']} · $code',
  'floor': floor,
  'status': 'sold',
  'project_id': 1,
  'building_id': building['id'],
  'building': building,
  'user_id': 77,
  'unit_value': unitValue,
  'maintenance_deposit_amount': 350000,
  'club_house_amount': 100000,
  'contract_total': 4950000,
  'main_image': null,
};

const _blockJson = {
  'id': 1,
  'type': 'block',
  'code': 'B1',
  'name': 'Block 1',
  'label': 'Block 1',
};
const _townJson = {
  'id': 2,
  'type': 'town',
  'code': 'T-5',
  'name': 'Town 5',
  'label': 'Town 5',
};
const _villaJson = {
  'id': 3,
  'type': 'villa',
  'code': 'V-3',
  'name': null,
  'label': 'V-3',
};

Building _block() => Building.fromJson({
  ..._blockJson,
  'units': [
    _owned(id: 1, code: 'B1-G-01', floor: 0, building: _blockJson),
    _owned(id: 3, code: 'B1-F-01', floor: 1, building: _blockJson),
  ],
});

Building _town() => Building.fromJson({
  ..._townJson,
  'units': [_owned(id: 5, code: 'T-5-S', floor: 1, building: _townJson)],
});

Building _villa() => Building.fromJson({
  ..._villaJson,
  'units': [
    _owned(
      id: 6,
      code: 'V-3',
      floor: null,
      building: _villaJson,
      unitValue: null,
    ),
  ],
});

/// [signedIn]: the user's buildings and their shapes. Signed out: no
/// buildings and no shapes, but the map's size is still sent.
///
/// [withImage]: the master plan picture. Its network placeholder never
/// settles, so only screens pumped without settling use it.
ProjectData _project({
  bool signedIn = true,
  bool withMap = true,
  bool withImage = false,
}) => ProjectData(
  id: 1,
  name: 'La Mer',
  mainImage: withImage
      ? const ProjectMedia(id: 10, url: 'https://x/plan.jpg')
      : null,
  media: const [
    ProjectMedia(id: 11, url: 'https://x/pool.jpg', mimeType: 'image/jpeg'),
  ],
  buildings: signedIn ? [_block(), _town(), _villa()] : const [],
  hasBuildingMapping: withMap && signedIn,
  buildingMapping: withMap
      ? BuildingMapping.fromJson({
          'imageWidth': 1600,
          'imageHeight': 900,
          'shapes': signedIn
              ? [
                  {
                    'id': 's1',
                    'shapeType': 'rect',
                    'buildingId': 1,
                    'points': [
                      [0.0, 0.0],
                      [0.5, 0.0],
                      [0.5, 0.5],
                      [0.0, 0.5],
                    ],
                  },
                  {
                    'id': 's2',
                    'shapeType': 'polygon',
                    'buildingId': 2,
                    'points': [
                      [0.6, 0.6],
                      [0.9, 0.6],
                      [0.9, 0.9],
                    ],
                  },
                ]
              : [],
        })
      : null,
);

void main() {
  tearDown(() => updateUserModel(null));

  group('MasterPlanMap.hitTest', () {
    final shapes = _project().linkedShapes;

    test('finds the building under a point', () {
      expect(MasterPlanMap.hitTest(const Offset(0.25, 0.25), shapes)?.id, 1);
      expect(MasterPlanMap.hitTest(const Offset(0.85, 0.8), shapes)?.id, 2);
    });

    test('returns null outside every building', () {
      expect(MasterPlanMap.hitTest(const Offset(0.55, 0.1), shapes), isNull);
      expect(MasterPlanMap.hitTest(const Offset(0.62, 0.85), shapes), isNull);
    });
  });

  testWidgets('tapping a building on the map reports it', (tester) async {
    Building? tapped;
    await pumpLocalized(
      tester,
      Center(
        child: SizedBox(
          width: 320,
          child: MasterPlanMap(
            project: _project(),
            onBuildingTapped: (b) => tapped = b,
          ),
        ),
      ),
    );
    final map = find.byType(MasterPlanMap);
    final topLeft = tester.getTopLeft(map);
    final size = tester.getSize(map);
    expect(size.width / size.height, closeTo(1600 / 900, 0.01));

    await tester.tapAt(topLeft + Offset(size.width * 0.2, size.height * 0.2));
    expect(tapped?.code, 'B1');

    tapped = null;
    await tester.tapAt(topLeft + Offset(size.width * 0.55, size.height * 0.1));
    expect(tapped, isNull);
  });

  group('BuildingUnitsSheet', () {
    testWidgets('block: owned units in full, grouped by floor', (tester) async {
      UnitSummary? news;
      await pumpLocalized(
        tester,
        SingleChildScrollView(
          child: BuildingUnitsSheet(
            building: _block(),
            units: _block().units,
            onViewNews: (u) => news = u,
          ),
        ),
      );

      expect(find.text('Block 1'), findsOneWidget);
      expect(find.text('Ground floor'), findsNWidgets(2)); // heading + card
      expect(find.text('Block 1 · B1-G-01'), findsOneWidget);
      expect(find.text('Unit value'), findsNWidgets(2));
      expect(find.text('4,500,000.00 EGP'), findsNWidgets(2));
      expect(find.text('Contract total'), findsNWidgets(2));
      expect(find.text('4,950,000.00 EGP'), findsNWidgets(2));
      // No sales data: an owned unit is always sold.
      expect(find.text('Sold'), findsNothing);
      expect(find.text('Available'), findsNothing);

      await tester.ensureVisible(find.text('View unit news').last);
      await tester.tap(find.text('View unit news').last);
      expect(news?.code, 'B1-F-01');
    });

    testWidgets('villa: no floor, a missing unit value is hidden', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        SingleChildScrollView(
          child: BuildingUnitsSheet(building: _villa(), units: _villa().units),
        ),
      );
      expect(find.text('Villa'), findsOneWidget);
      expect(find.text('Ground floor'), findsNothing);
      expect(find.text('Unit value'), findsNothing);
      expect(find.text('Contract total'), findsOneWidget);
      expect(find.text('View unit news'), findsNothing);
    });

    testWidgets('Arabic labels match the admin panel', (tester) async {
      await pumpLocalized(
        tester,
        SingleChildScrollView(
          child: BuildingUnitsSheet(building: _block(), units: _block().units),
        ),
        locale: const Locale('ar'),
      );
      expect(find.text('بلوك'), findsOneWidget);
      expect(find.text('الدور الأرضي'), findsWidgets);
      expect(find.text('قيمة الوحدة'), findsNWidgets(2));
    });
  });

  testWidgets('tapping the plan away from a building opens it full screen', (
    tester,
  ) async {
    var zoomed = 0;
    Building? tapped;
    await pumpLocalized(
      tester,
      Center(
        child: SizedBox(
          width: 320,
          child: MasterPlanMap(
            project: _project(),
            onBuildingTapped: (b) => tapped = b,
            onTapElsewhere: () => zoomed++,
          ),
        ),
      ),
    );
    final map = find.byType(MasterPlanMap);
    final topLeft = tester.getTopLeft(map);
    final size = tester.getSize(map);

    // On a building: opens the building, not the zoom view.
    await tester.tapAt(topLeft + Offset(size.width * 0.2, size.height * 0.2));
    expect(tapped?.code, 'B1');
    expect(zoomed, 0);

    // Anywhere else: zoom.
    await tester.tapAt(topLeft + Offset(size.width * 0.55, size.height * 0.1));
    expect(zoomed, 1);
  });

  group('MasterPlanFullScreen', () {
    Future<InteractiveViewer> pumpViewer(WidgetTester tester) async {
      await pumpLocalized(
        tester,
        MasterPlanFullScreen(project: _project(withImage: true)),
        wrapInScaffold: false,
        settle: false,
      );
      return tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    }

    // Two taps in a row: `tapAt` twice is too slow to count as a double tap.
    Future<void> doubleTap(WidgetTester tester, Offset at) async {
      for (var i = 0; i < 2; i++) {
        final tap = await tester.startGesture(at);
        await tap.up();
        await tester.pump(const Duration(milliseconds: 50));
      }
      await pumpFrames(tester);
    }

    double scaleOf(WidgetTester tester) => tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!
        .value
        .getMaxScaleOnAxis();

    testWidgets('pinch range, double-tap zooms in and back out', (
      tester,
    ) async {
      final viewer = await pumpViewer(tester);
      expect(viewer.minScale, 1);
      expect(viewer.maxScale, 8);
      expect(scaleOf(tester), 1);

      final plan = tester.getRect(find.byType(MasterPlanMap));
      final empty = plan.topLeft + Offset(plan.width * 0.55, plan.height * 0.1);

      await doubleTap(tester, empty);
      expect(scaleOf(tester), greaterThan(2));

      await doubleTap(tester, empty);
      expect(scaleOf(tester), closeTo(1, 0.01));
    });

    testWidgets('the zoom buttons zoom in and out', (tester) async {
      await pumpViewer(tester);
      // Zooming out is off until there is something to zoom back from.
      expect(
        tester
            .widget<IconButton>(
              find.widgetWithIcon(IconButton, Icons.remove_rounded),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byIcon(Icons.add_rounded));
      await pumpFrames(tester);
      final zoomed = scaleOf(tester);
      expect(zoomed, greaterThan(1));

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await pumpFrames(tester);
      expect(scaleOf(tester), lessThan(zoomed));
    });

    testWidgets('opened on a building, zooms to it and centres it', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        MasterPlanFullScreen(project: _project(), focusBuildingId: 2),
        wrapInScaffold: false,
        settle: false,
      );
      await pumpFrames(tester);
      // A large shape (30% of the plan) needs only a little zoom.
      expect(scaleOf(tester), greaterThan(1.2));

      // The town's shape (0.6–0.9 of the plan) is now in the middle.
      final controller = tester
          .widget<InteractiveViewer>(find.byType(InteractiveViewer))
          .transformationController!;
      final viewer = tester.getRect(find.byType(InteractiveViewer));
      final map = tester.renderObject<RenderBox>(find.byType(MasterPlanMap));
      final plan = map.size;
      final corner = controller.toScene(
        map.localToGlobal(Offset.zero) - viewer.topLeft,
      );
      final townCentre = MatrixUtils.transformPoint(
        controller.value,
        corner + Offset(plan.width * 0.75, plan.height * 0.75),
      );
      expect(
        (townCentre - viewer.size.center(Offset.zero)).distance,
        lessThan(viewer.shortestSide / 4),
      );
    });
  });

  testWidgets('MyUnitsOverview groups units by building and floor', (
    tester,
  ) async {
    UnitSummary? tapped;
    await pumpLocalized(
      tester,
      SingleChildScrollView(
        child: MyUnitsOverview(
          buildings: [_block(), _town(), _villa()],
          onUnitTapped: (_, u) => tapped = u,
        ),
      ),
    );
    expect(find.text('Block 1'), findsOneWidget);
    expect(find.text('Town 5'), findsOneWidget);
    expect(find.text('B1-G-01 · Ground floor'), findsOneWidget);
    expect(find.text('T-5-S · Upper floor'), findsOneWidget);
    expect(find.text('V-3'), findsWidgets);
    expect(find.text('4,950,000.00 EGP'), findsNWidgets(4));

    await tester.tap(find.text('Town 5 · T-5-S'));
    expect(tapped?.id, 5);
  });

  testWidgets('MyUnitsOverview: "show on the map" only for mapped buildings', (
    tester,
  ) async {
    Building? shown;
    await pumpLocalized(
      tester,
      SingleChildScrollView(
        child: MyUnitsOverview(
          buildings: [_block(), _town(), _villa()],
          onUnitTapped: (_, _) {},
          // The villa has no shape on the plan.
          mappedBuildingIds: const {1, 2},
          onShowOnMap: (b) => shown = b,
        ),
      ),
    );
    // Block 1 has two units, Town 5 one: one button per unit row.
    final buttons = find.byIcon(Icons.location_searching_rounded);
    expect(buttons, findsNWidgets(3));

    await tester.tap(buttons.last);
    expect(shown?.id, 2);
  });

  testWidgets('UnitInfoCard shows building, code, floor and status', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      UnitInfoCard(
        building: _town(),
        code: 'T-5-S',
        floor: 1,
        status: UnitStatus.sold,
      ),
    );
    expect(find.text('Town 5 · Town'), findsOneWidget);
    expect(find.text('T-5-S'), findsOneWidget);
    expect(find.text('Upper floor'), findsOneWidget);
    expect(find.text('Sold'), findsOneWidget);
  });

  test('unit code field upper-cases input', () {
    final result = const UnitCodeInputFormatter().formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: 'b1-g-01',
        selection: TextSelection.collapsed(offset: 7),
      ),
    );
    expect(result.text, 'B1-G-01');
  });

  group('ProjectDetails screen', () {
    Future<void> pumpScreen(WidgetTester tester, ProjectData project) async {
      final controller = ProjectController()
        ..projectDetailsResponseModel = ProjectDetailsResponseModel(
          success: true,
          data: project,
        );
      addTearDown(controller.close);
      await pumpLocalized(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: controller),
            BlocProvider(create: (_) => UnitEventController()),
          ],
          child: const ProjectDetails(),
        ),
        wrapInScaffold: false,
        settle: false,
      );
    }

    testWidgets('signed in: my buildings on the map and my units', (
      tester,
    ) async {
      await signIn();
      await pumpScreen(tester, _project(withImage: true));

      expect(find.byType(MasterPlanMap), findsOneWidget);
      expect(find.text('Your buildings'), findsOneWidget);
      expect(find.text('Has available units'), findsNothing);
      expect(find.textContaining('available'), findsNothing);
      expect(
        find.text(
          'Tap one of your buildings to see your units, or tap the plan to '
          'zoom in.',
        ),
        findsOneWidget,
      );
      expect(find.text('My Units'), findsOneWidget);
      expect(find.text('Project Gallery'), findsOneWidget);

      await tester.ensureVisible(find.text('Block 1 · B1-G-01'));
      await tester.tap(find.text('Block 1 · B1-G-01'));
      await pumpFrames(tester);
      expect(find.byType(BuildingUnitsSheet), findsOneWidget);
      expect(find.byType(OwnedUnitDetails), findsOneWidget);
    });

    testWidgets('signed out: master plan, info and gallery only', (
      tester,
    ) async {
      await pumpScreen(tester, _project(signedIn: false, withImage: true));

      expect(find.byType(MasterPlanMap), findsOneWidget);
      expect(find.text('Your buildings'), findsNothing);
      expect(find.byType(MyUnitsOverview), findsNothing);
      expect(
        find.text('Sign in to see your units and their news.'),
        findsOneWidget,
      );
      // News is owner-only: no timeline.
      expect(
        find.text('Follow your project\'s events and milestones'),
        findsNothing,
      );
      await tester.ensureVisible(find.text('Project Gallery'));
      expect(find.text('Project Gallery'), findsOneWidget);
    });

    testWidgets('signed in, owning nothing here', (tester) async {
      await signIn();
      await pumpScreen(tester, _project(signedIn: false, withImage: true));

      expect(
        find.text("You don't own any units in this project."),
        findsOneWidget,
      );
      expect(find.byType(MyUnitsOverview), findsNothing);
    });

    testWidgets('without a building map, my units are still reachable', (
      tester,
    ) async {
      await signIn();
      await pumpScreen(tester, _project(withMap: false));

      expect(find.text('Your buildings'), findsNothing);
      await tester.ensureVisible(find.text('V-3 · V-3'));
      await tester.tap(find.text('V-3 · V-3'));
      await pumpFrames(tester);
      expect(find.byType(BuildingUnitsSheet), findsOneWidget);
    });
  });
}
