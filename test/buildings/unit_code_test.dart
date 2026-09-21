import 'package:diyar_app/core/formatter/unit_code.dart';
import 'package:diyar_app/core/model/building_models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Types [text] one character at a time through the formatter, the way a
/// resident does, and returns what the field ends up holding.
String typed(String text) {
  var value = TextEditingValue.empty;
  const formatter = UnitCodeInputFormatter();
  for (final char in text.split('')) {
    final next = TextEditingValue(
      text: value.text + char,
      selection: TextSelection.collapsed(offset: value.text.length + 1),
    );
    value = formatter.formatEditUpdate(value, next);
  }
  return value.text;
}

/// One backspace at the end of [value].
String backspace(String value) {
  const formatter = UnitCodeInputFormatter();
  final shorter = value.substring(0, value.length - 1);
  return formatter
      .formatEditUpdate(
        TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        ),
        TextEditingValue(
          text: shorter,
          selection: TextSelection.collapsed(offset: shorter.length),
        ),
      )
      .text;
}

void main() {
  group('parsing', () {
    test('blocks: B<block>-<floor>-<unit>', () {
      final unit = UnitCode.tryParse('B1-G-01')!;
      expect(unit.type, BuildingType.block);
      expect(unit.block, '1');
      expect(unit.number, '01');
      expect(unit.floor, 0);
      expect(unit.code, 'B1-G-01');

      expect(UnitCode.tryParse('B1-F-08')!.floor, 1);
      expect(UnitCode.tryParse('B12-S-04')!.block, '12');
      expect(UnitCode.tryParse('B7-T-11')!.floor, 3);
    });

    test('towns: T-<town>-<floor>', () {
      final unit = UnitCode.tryParse('T-35-G')!;
      expect(unit.type, BuildingType.town);
      expect(unit.block, isNull);
      expect(unit.number, '35');
      expect(unit.floor, 0);
      expect(UnitCode.tryParse('T-5-S')!.floor, 2);
    });

    test('villas: V-<villa>, no floor', () {
      final unit = UnitCode.tryParse('V-1')!;
      expect(unit.type, BuildingType.villa);
      expect(unit.number, '1');
      expect(unit.floor, isNull);
      expect(UnitCode.tryParse('V-124')!.number, '124');
    });

    test('lower case, spaces, missing dashes and Arabic digits all parse', () {
      for (final input in [' b1-g-01 ', 'b1g01', 'B1 G 01', 'B١-G-٠١']) {
        expect(UnitCode.tryParse(input)?.code, 'B1-G-01', reason: input);
      }
      expect(UnitCode.tryParse('t35g')?.code, 'T-35-G');
      expect(UnitCode.tryParse('v1')?.code, 'V-1');
    });

    test('a block unit number is padded to two digits', () {
      expect(UnitCode.tryParse('B1-G-1')!.code, 'B1-G-01');
      // Nothing is truncated: a three-digit unit stays as typed.
      expect(UnitCode.tryParse('B1-G-012')!.code, 'B1-G-012');
      // Towns and villas aren't padded.
      expect(UnitCode.tryParse('T-5-G')!.code, 'T-5-G');
      expect(UnitCode.tryParse('V-1')!.code, 'V-1');
    });

    test('incomplete or unknown shapes do not parse', () {
      for (final input in [
        '',
        'B',
        'B1',
        'B1-G', // no unit number
        'B-G-01', // no block
        'B1-X-01', // X isn't a floor
        'T-35', // no floor
        'T-G', // no town number
        'V', // no villa number
        'V-1-G', // villas have no floor
        'X-1-G', // unknown type
        'B1-G-0123', // trailing junk
      ]) {
        expect(UnitCode.tryParse(input), isNull, reason: input);
      }
    });
  });

  group('normalize', () {
    test('canonical for codes we know', () {
      expect(UnitCode.normalize(' b1g1 '), 'B1-G-01');
      expect(UnitCode.normalize('t-35-g'), 'T-35-G');
      expect(UnitCode.normalize('v-1'), 'V-1');
    });

    test(
      'a shape we do not know is trimmed and upper-cased, not rewritten',
      () {
        expect(UnitCode.normalize(' c3-2 '), 'C3-2');
        expect(UnitCode.normalize('B1-G'), 'B1-G');
      },
    );
  });

  group('input mask', () {
    test('dashes appear as the next character is typed', () {
      expect(typed('b'), 'B');
      expect(typed('b1'), 'B1');
      expect(typed('b1g'), 'B1-G');
      expect(typed('b1g0'), 'B1-G-0');
      expect(typed('b1g01'), 'B1-G-01');
      expect(typed('b12g01'), 'B12-G-01');
      expect(typed('t'), 'T');
      expect(typed('t35'), 'T-35');
      expect(typed('t35g'), 'T-35-G');
      expect(typed('v1'), 'V-1');
    });

    test('the dashes the resident types are not doubled', () {
      expect(typed('B1-G-01'), 'B1-G-01');
      expect(typed('T-35-G'), 'T-35-G');
      expect(typed('V-1'), 'V-1');
    });

    test('characters the shape cannot hold are dropped', () {
      expect(typed('b1g01x'), 'B1-G-01'); // no room after the unit number
      expect(typed('b1g0123'), 'B1-G-012'); // three digits at most
      expect(typed('bg'), 'B'); // the block number has to come first
      expect(typed('v1g'), 'V-1'); // villas have no floor
    });

    test('backspacing walks back out of the code, dashes and all', () {
      var value = typed('b1g01');
      for (final step in ['B1-G-0', 'B1-G', 'B1', 'B', '']) {
        value = backspace(value);
        expect(value, step);
      }
    });

    test('a code of no known shape is left exactly as typed', () {
      expect(typed('c3-2/a'), 'C3-2/A');
    });

    test('editing in the middle is left alone beyond upper-casing', () {
      const formatter = UnitCodeInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: 'B1-G-01'),
        const TextEditingValue(
          text: 'B1-g-01',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );
      expect(result.text, 'B1-G-01');
      expect(result.selection.baseOffset, 4);
    });

    test('a pasted code is put into shape', () {
      const formatter = UnitCodeInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(
          text: ' b1 g 1 ',
          selection: TextSelection.collapsed(offset: 8),
        ),
      );
      expect(result.text, 'B1-G-1');
    });
  });
}
