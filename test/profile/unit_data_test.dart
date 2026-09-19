import 'package:diyar_app/feature/profile/model/unit_model_details_for_linked_user.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// The full unit from MOBILE-API-CHANGES-BUILDINGS.md §4.3.
Map<String, dynamic> fullUnitJson() => {
  'id': 5,
  'code': 'T-1-G',
  'name': null,
  'label': 'Town 1 · T-1-G',
  'floor': 0,
  'status': 'sold',
  'project_id': 1,
  'building_id': 2,
  'building': {
    'id': 2,
    'type': 'town',
    'code': 'T-1',
    'name': 'Town 1',
    'label': 'Town 1',
  },
  'user_id': 1,
  'unit_value': 100000,
  'maintenance_deposit_amount': 0,
  'club_house_amount': 0,
  'contract_total': 100000,
  'main_image': null,
  'news': [
    {
      'id': 3,
      'title': 'Handover',
      'content': 'Keys are ready',
      'news_date': '2026-09-01',
      'media': [],
      'unit': {
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
      },
      'project': {'id': 1, 'name': 'La Mer', 'has_building_mapping': false},
    },
  ],
};

void main() {
  test('GET /api/units/{id} parses the new unit shape', () {
    final model = UnitModelDetailsForLinkedUserResponseModel.fromJson({
      'success': true,
      'data': fullUnitJson(),
    });
    final unit = model.data!;

    expect(unit.code, 'T-1-G');
    expect(unit.name, isNull);
    expect(unit.label, 'Town 1 · T-1-G');
    expect(unit.floor, 0);
    expect(unit.status, UnitStatus.sold);
    expect(unit.projectId, 1);
    expect(unit.buildingId, 2);
    // The building is an object now, not a string like "A".
    expect(unit.building!.type, BuildingType.town);
    expect(unit.building!.label, 'Town 1');
    expect(unit.unitValue, 100000);
    expect(unit.contractTotal, 100000);

    final news = unit.news!.single;
    expect(news.unit!.label, 'Town 1 · T-1-G');
    expect(news.unit!.building!.code, 'T-1');
    expect(news.project!.name, 'La Mer');

    final json = unit.toJson();
    expect(json['code'], 'T-1-G');
    expect(json.containsKey('number'), isFalse);
    expect(json.containsKey('building'), isFalse);
  });

  test('a missing or failed response does not crash', () {
    expect(
      UnitModelDetailsForLinkedUserResponseModel.fromJson(null).data,
      isNull,
    );
    expect(
      UnitModelDetailsForLinkedUserResponseModel.fromJson('<html>').success,
      isFalse,
    );
  });

  test('GET /api/units items expose code, label, floor, status, building', () {
    final model = UserUnitsResponseModel.fromJson({
      'success': true,
      'data': [
        fullUnitJson(),
        {'id': 9, 'code': 'V-3', 'name': null, 'floor': null, 'status': 'sold'},
      ],
    });
    final town = model.data!.first;
    expect(town.label, 'Town 1 · T-1-G');
    expect(town.code, 'T-1-G');
    expect(town.building!.type, BuildingType.town);
    expect(town.status, UnitStatus.sold);

    // No label from the API: falls back to the code, never blank.
    final villa = model.data!.last;
    expect(villa.label, 'V-3');
    expect(villa.floor, isNull);
  });
}
