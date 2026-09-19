// Tests for the "Project Timeline" feature data contracts:
// - the user's projects response (used to resolve which project to open), and
// - the project details building map (buildings drawn on the master plan).
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/project/model/projects_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProjectsResponseModel (projects/user)', () {
    test('parses a list of the user\'s projects', () {
      final json = {
        'success': true,
        'message': 'User projects fetched successfully',
        'data': [
          {
            'id': 7,
            'name': "La'Mer Residences",
            'main_image': {'id': 5, 'url': 'https://example.com/p.jpg'},
            'media': [],
          },
        ],
      };

      final model = ProjectsResponseModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.length, 1);
      expect(model.data!.first.id, 7);
      expect(model.data!.first.name, "La'Mer Residences");
      expect(model.data!.first.mainImage?.url, 'https://example.com/p.jpg');
    });

    test('tolerates a null data payload', () {
      final model = ProjectsResponseModel.fromJson({
        'success': false,
        'message': 'Failed',
        'data': null,
      });
      expect(model.success, isFalse);
      expect(model.data, isNull);
    });
  });

  group('ProjectDetailsResponseModel building mapping', () {
    test('links map shapes to buildings and skips unknown ones', () {
      final json = {
        'success': true,
        'message': 'ok',
        'data': {
          'id': 1,
          'name': 'La Mer',
          'description': 'desc',
          'main_image': {'id': 2, 'url': 'https://example.com/plan.jpg'},
          'media': [],
          'buildings': [
            {
              'id': 1,
              'type': 'block',
              'code': 'B1',
              'name': 'Block 1',
              'label': 'Block 1',
              'unit_counts': {
                'total': 2,
                'available': 1,
                'reserved': 0,
                'sold': 1,
              },
              'units': [
                {
                  'id': 1,
                  'code': 'B1-G-01',
                  'name': null,
                  'label': 'B1-G-01',
                  'floor': 0,
                  'status': 'available',
                },
              ],
            },
          ],
          'has_building_mapping': true,
          'building_mapping': {
            'version': '1.0',
            'imageWidth': 1600,
            'imageHeight': 900,
            'shapes': [
              {
                'id': 'shape_1',
                'shapeType': 'polygon',
                'buildingId': 1,
                'points': [
                  [0.1, 0.1],
                  [0.3, 0.1],
                  [0.3, 0.4],
                ],
              },
              {
                'id': 'shape_2',
                'shapeType': 'rect',
                // Building deleted since the map was drawn.
                'buildingId': 99,
                'points': [
                  [0.5, 0.5],
                  [0.6, 0.5],
                  [0.6, 0.6],
                  [0.5, 0.6],
                ],
              },
            ],
          },
        },
      };

      final data = ProjectDetailsResponseModel.fromJson(json).data!;

      expect(data.hasBuildingMapping, isTrue);
      expect(data.buildingMapping!.aspectRatio, closeTo(1600 / 900, 1e-9));
      expect(data.buildingMapping!.shapes, hasLength(2));
      expect(data.buildingMapping!.shapes.first.points.first, [0.1, 0.1]);

      final linked = data.linkedShapes;
      expect(linked, hasLength(1));
      expect(linked.single.$1.id, 'shape_1');
      expect(linked.single.$2.code, 'B1');
    });

    test('no shapes when has_building_mapping is false', () {
      final data = ProjectDetailsResponseModel.fromJson({
        'success': true,
        'data': {'id': 1, 'has_building_mapping': false, 'buildings': []},
      }).data!;
      expect(data.hasBuildingMapping, isFalse);
      expect(data.buildingMapping, isNull);
      expect(data.linkedShapes, isEmpty);
    });
  });
}
