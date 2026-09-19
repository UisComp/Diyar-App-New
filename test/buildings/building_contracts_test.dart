// Data contracts from MOBILE-API-CHANGES-BUILDINGS.md (2026-09-18) and
// MOBILE-API-CHANGES-MASTER-PLAN-2026-09-19.md.
import 'package:diyar_app/core/model/news_response_model.dart';
import 'package:diyar_app/feature/finance/model/finance_response_model.dart'
    show FinanceUnit, Installment;
import 'package:diyar_app/feature/news/model/news_details_response_model.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/unit_event/model/news_by_project_unit_event_response_model.dart';
import 'package:diyar_app/feature/visitor/model/visitor_pass_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> unitSummaryJson() => {
  'id': 5,
  'code': 'T-1-G',
  'name': null,
  'label': 'Town 1 · T-1-G',
  'floor': 0,
  'status': 'sold',
  'building': {
    'id': 2,
    'type': 'town',
    'code': 'T-1',
    'name': 'Town 1',
    'label': 'Town 1',
  },
};

void main() {
  group('Building / UnitSummary', () {
    test('parses a building holding an owned unit, in full', () {
      final b = Building.fromJson({
        'id': 23,
        'type': 'town',
        'code': 'T-1',
        'name': 'Town 1',
        'label': 'Town 1',
        'units': [
          {
            ...unitSummaryJson(),
            'id': 412,
            'project_id': 1,
            'building_id': 23,
            'user_id': 77,
            'unit_value': 4500000,
            'maintenance_deposit_amount': 350000.5,
            'club_house_amount': '100000',
            'contract_total': 4950000,
            'main_image': {
              'id': 90,
              'url': 'https://x/t1-g.jpg',
              'mime_type': 'image/jpeg',
            },
          },
        ],
      });
      expect(b.type, BuildingType.town);
      expect(b.label, 'Town 1');
      final u = b.units.single;
      expect(u.label, 'Town 1 · T-1-G');
      expect(u.building!.id, 2);
      expect(u.unitValue, 4500000);
      expect(u.maintenanceDepositAmount, 350000.5);
      expect(u.clubHouseAmount, 100000);
      expect(u.contractTotal, 4950000);
      expect(u.imageUrl, 'https://x/t1-g.jpg');
      expect(u.hasMoney, isTrue);
    });

    test('money and image are optional (unit_value can be null)', () {
      final u = UnitSummary.fromJson({
        ...unitSummaryJson(),
        'unit_value': null,
        'main_image': null,
      });
      expect(u.unitValue, isNull);
      expect(u.imageUrl, isNull);
      expect(u.hasMoney, isFalse);
    });

    test('parses a unit summary with its building', () {
      final u = UnitSummary.fromJson(unitSummaryJson());
      expect(u.label, 'Town 1 · T-1-G');
      expect(u.name, isNull);
      expect(u.floor, 0);
      expect(u.status, UnitStatus.sold);
      expect(u.building!.type, BuildingType.town);
    });

    test('label falls back to name, then code', () {
      expect(UnitSummary.fromJson({'code': 'V-3'}).label, 'V-3');
      expect(
        UnitSummary.fromJson({'code': 'V-3', 'name': 'Sea villa'}).label,
        'Sea villa',
      );
      expect(Building.fromJson({'code': 'B2'}).label, 'B2');
    });

    test('unknown enum values do not crash', () {
      final u = UnitSummary.fromJson({'status': 'leased'});
      expect(u.status, UnitStatus.unknown);
      expect(Building.fromJson({'type': 'tower'}).type, BuildingType.unknown);
    });

    test('groups units by floor, ground first; villas have one group', () {
      final block = Building.fromJson({
        'type': 'block',
        'units': [
          {'code': 'B1-F-01', 'floor': 1},
          {'code': 'B1-G-01', 'floor': 0},
          {'code': 'B1-G-02', 'floor': 0},
          {'code': 'B9-4-01', 'floor': 4},
        ],
      });
      expect(block.unitsByFloor.map((g) => g.$1), [0, 1, 4]);
      expect(block.unitsByFloor.first.$2.map((u) => u.code), [
        'B1-G-01',
        'B1-G-02',
      ]);

      final villa = Building.fromJson({
        'type': 'villa',
        'units': [
          {'code': 'V-3', 'floor': null},
        ],
      });
      expect(villa.unitsByFloor.single.$1, isNull);
    });
  });

  group('GET /api/projects/{id}', () {
    Map<String, dynamic> map({List<dynamic> shapes = const []}) => {
      'version': '1.0',
      'imageWidth': 2400,
      'imageHeight': 3400,
      'shapes': shapes,
    };

    test('signed in: own buildings, their shapes and the gallery', () {
      final p = ProjectDetailsResponseModel.fromJson({
        'success': true,
        'message': 'Project fetched successfully',
        'data': {
          'id': 1,
          'name': 'La Mer',
          'buildings': [
            {
              'id': 23,
              'type': 'town',
              'code': 'T-1',
              'label': 'Town 1',
              'units': [unitSummaryJson()],
            },
          ],
          'main_image': {'id': 10, 'url': 'https://x/plan.jpg'},
          'media': [
            {'id': 11, 'url': 'https://x/pool.jpg', 'mime_type': 'image/jpeg'},
            {'id': 12, 'url': 'https://x/tour.mp4', 'mime_type': 'video/mp4'},
            {'id': 13, 'url': 'https://x/old.png'},
          ],
          'has_building_mapping': true,
          'building_mapping': map(
            shapes: [
              {
                'id': 'shape_23',
                'shapeType': 'polygon',
                'buildingId': 23,
                'points': [
                  [0.71, 0.61],
                  [0.74, 0.61],
                  [0.74, 0.66],
                ],
              },
              // A shape without a returned building is skipped.
              {
                'id': 'shape_99',
                'shapeType': 'rect',
                'buildingId': 99,
                'points': [
                  [0.1, 0.1],
                  [0.2, 0.1],
                  [0.2, 0.2],
                ],
              },
            ],
          ),
        },
      }).data!;
      expect(p.buildings.single.units.single.code, 'T-1-G');
      expect(p.linkedShapes.single.$2.id, 23);
      // Images only; a missing mime_type (older backend) counts as one.
      expect(p.gallery.map((m) => m.id), [11, 13]);
    });

    test('signed out: no buildings, but the map size is still sent', () {
      final p = ProjectDetailsResponseModel.fromJson({
        'success': true,
        'data': {
          'id': 1,
          'name': 'La Mer',
          'buildings': [],
          'main_image': {'id': 10, 'url': 'https://x/plan.jpg'},
          'media': [],
          'has_building_mapping': false,
          'building_mapping': map(),
        },
      }).data!;
      expect(p.buildings, isEmpty);
      expect(p.linkedShapes, isEmpty);
      expect(p.buildingMapping!.aspectRatio, closeTo(2400 / 3400, 1e-9));
      expect(p.gallery, isEmpty);
    });
  });

  group('Other payloads carrying a unit', () {
    test('finance units expose unit_code, unit_label and building', () {
      final unit = FinanceUnit.fromJson({
        'unit_id': 5,
        'unit_code': 'T-1-G',
        'unit_name': null,
        'unit_label': 'Town 1 · T-1-G',
        'building': unitSummaryJson()['building'],
        'installments': [],
      });
      expect(unit.label, 'Town 1 · T-1-G');
      expect(unit.unitCode, 'T-1-G');
      expect(unit.building!.type, BuildingType.town);

      expect(FinanceUnit.fromJson({'unit_code': 'V-3'}).label, 'V-3');
    });

    test('upcoming installment rows carry a UnitSummary', () {
      final row = Installment.fromJson({'id': 1, 'unit': unitSummaryJson()});
      expect(row.unit!.label, 'Town 1 · T-1-G');
      expect(row.unit!.code, 'T-1-G');
    });

    test('news payloads parse the UnitSummary and new project keys', () {
      final newsItem = {
        'id': 1,
        'title': 't',
        'content': 'c',
        'news_date': '2026-09-01',
        'media': [],
        'unit': unitSummaryJson(),
        'project': {'id': 1, 'name': 'La Mer', 'has_building_mapping': false},
      };

      final list = NewsResponseModel.fromJson({
        'success': true,
        'data': [newsItem],
      });
      expect(list.data!.single.unit!.id, 5);

      final details = NewsDetailsResponseModel.fromJson({
        'success': true,
        'data': newsItem,
      });
      expect(details.data!.unit!.id, 5);
      expect(details.data!.project!.name, 'La Mer');

      final byUnit = NewByProjectUnitEventResponseModel.fromJson({
        'success': true,
        'data': [newsItem],
      });
      expect(byUnit.data!.single.unit!.id, 5);
    });

    test('visitor pass unit parses with a null name', () {
      final pass = VisitorPassResponse.fromJson({
        'success': true,
        'data': {
          'unit': {
            'id': 5,
            'code': 'T-1-G',
            'name': null,
            'label': 'Town 1 · T-1-G',
          },
        },
      });
      expect(pass.data!.unit!.id, 5);
    });
  });
}
