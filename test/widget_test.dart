// Tests for the "Project Timeline" feature data contracts:
// - the user's projects response (used to resolve which project to open), and
// - the project details unit-mapping (used to drive the interactive image and
//   the inline events calendar).
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

  group('ProjectDetailsResponseModel unit mapping', () {
    test('parses mapped and unmapped sections', () {
      final json = {
        'success': true,
        'message': 'ok',
        'data': {
          'id': 1,
          'name': 'Project',
          'description': 'desc',
          'main_image': {'id': 2, 'url': 'https://example.com/main.jpg'},
          'media': [],
          'has_unit_mapping': true,
          'unit_mapping': {
            'version': '1.0',
            'imageWidth': 1000,
            'imageHeight': 800,
            'shapes': [
              {
                'id': 's1',
                'shapeType': 'polygon',
                'unitId': 42,
                'points': [
                  [0.1, 0.1],
                  [0.2, 0.1],
                  [0.2, 0.2],
                ],
              },
              {
                'id': 's2',
                'shapeType': 'polygon',
                'unitId': null,
                'points': [
                  [0.5, 0.5],
                  [0.6, 0.5],
                  [0.6, 0.6],
                ],
              },
            ],
          },
        },
      };

      final model = ProjectDetailsResponseModel.fromJson(json);
      final mapping = model.data?.unitMapping;

      expect(model.data?.hasUnitMapping, isTrue);
      expect(mapping, isNotNull);
      expect(mapping!.imageWidth, 1000);
      expect(mapping.imageHeight, 800);
      expect(mapping.shapes!.length, 2);

      // A mapped section exposes a unitId -> drives the inline calendar.
      final mapped = mapping.shapes!.first;
      expect(mapped.unitId, 42);
      expect(mapped.points!.first, [0.1, 0.1]);

      // An unmapped section has a null unitId -> shows the "no events" message.
      final unmapped = mapping.shapes!.last;
      expect(unmapped.unitId, isNull);
    });
  });
}
