import 'package:diyar_app/core/model/building_models.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Unit codes as the client's sheets write them. One shape per building
/// type:
///
/// | Type  | Shape                     | Examples              |
/// |-------|---------------------------|-----------------------|
/// | Block | `B<block>-<floor>-<unit>` | `B1-G-01` … `B1-F-08` |
/// | Town  | `T-<town>-<floor>`        | `T-35-G`, `T-5-S`     |
/// | Villa | `V-<villa>`               | `V-1`                 |
///
/// The floor is a letter: G ground, F first, S second, T third — see
/// [unitFloorLetters]. Everything that differs between the shapes lives in
/// [unitCodeShapes]: the input mask, the validator, the canonical form and
/// the labels all read off that one table, so a fourth shape (or a fifth
/// floor letter) is one entry here instead of a new regular expression in
/// three places.

/// Floor letters, in floor order, matching the API's numeric `floor`
/// (0 = ground). Add a letter here and every shape accepts it.
const Map<String, int> unitFloorLetters = {'G': 0, 'F': 1, 'S': 2, 'T': 3};

bool _isDigit(String char) {
  final code = char.codeUnitAt(0);
  return code >= 0x30 && code <= 0x39;
}

/// Arabic-Indic digits are read as their ASCII twins (`٠١٢` → `012`), so a
/// resident typing on an Arabic keyboard gets the same code. One rune in,
/// one rune out: offsets in the field stay put.
String _asciiDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(rune - 0x0660 + 0x30); // ٠-٩
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(rune - 0x06F0 + 0x30); // ۰-۹
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// One segment of a code: a number (`1`, `35`, `01`) or a floor letter.
class UnitCodePart {
  const UnitCodePart.number({this.maxDigits = 3, this.padTo = 1})
    : isFloor = false;

  const UnitCodePart.floor() : isFloor = true, maxDigits = 1, padTo = 1;

  final bool isFloor;

  /// How many digits this segment takes at most; typing past it does
  /// nothing.
  final int maxDigits;

  /// Zero-padded to this width in the canonical code: block units are
  /// written `01`, so `B1-G-1` is the same unit as `B1-G-01`.
  final int padTo;

  /// The longest run of [source] from [start] this segment accepts, or `''`
  /// when the next character isn't one of ours.
  String take(String source, int start) {
    if (start >= source.length) return '';
    if (isFloor) {
      final letter = source[start];
      return unitFloorLetters.containsKey(letter) ? letter : '';
    }
    var end = start;
    while (end < source.length &&
        end - start < maxDigits &&
        _isDigit(source[end])) {
      end++;
    }
    return source.substring(start, end);
  }

  String canonical(String digits) =>
      isFloor ? digits : digits.padLeft(padTo, '0');
}

/// The grammar of one building type's codes.
class UnitCodeShape {
  const UnitCodeShape({
    required this.type,
    required this.prefix,
    required this.parts,
    required this.example,
    this.prefixJoined = false,
  });

  final BuildingType type;

  /// The letter the code starts with: `B`, `T` or `V`.
  final String prefix;

  final List<UnitCodePart> parts;

  /// `B1` keeps the block number against the prefix; `T-35` and `V-1` put a
  /// dash after it.
  final bool prefixJoined;

  /// Shown to the resident when the code doesn't parse.
  final String example;

  /// The shape [code] starts with, or null when the first letter is none of
  /// ours.
  static UnitCodeShape? of(String code) {
    final raw = UnitCode.rawOf(code);
    if (raw.isEmpty) return null;
    for (final shape in unitCodeShapes) {
      if (shape.prefix == raw[0]) return shape;
    }
    return null;
  }
}

/// The three shapes the project sells. Add a type here to support it
/// everywhere at once.
const List<UnitCodeShape> unitCodeShapes = [
  UnitCodeShape(
    type: BuildingType.block,
    prefix: 'B',
    prefixJoined: true,
    parts: [
      UnitCodePart.number(maxDigits: 3), // block
      UnitCodePart.floor(),
      UnitCodePart.number(maxDigits: 3, padTo: 2), // unit
    ],
    example: 'B1-G-01',
  ),
  UnitCodeShape(
    type: BuildingType.town,
    prefix: 'T',
    parts: [UnitCodePart.number(maxDigits: 4), UnitCodePart.floor()],
    example: 'T-35-G',
  ),
  UnitCodeShape(
    type: BuildingType.villa,
    prefix: 'V',
    parts: [UnitCodePart.number(maxDigits: 4)],
    example: 'V-1',
  ),
];

/// A unit code that parsed: which shape it is, its parts, and the canonical
/// text to send the server.
class UnitCode {
  const UnitCode._({
    required this.shape,
    required this.numbers,
    required this.floor,
    required this.code,
  });

  final UnitCodeShape shape;

  /// The number segments in order: `[block, unit]` for a block, `[town]` or
  /// `[villa]` otherwise. Canonical, so padding is already applied.
  final List<String> numbers;

  /// 0 = ground, as the API counts floors. Null for villas.
  final int? floor;

  /// Trimmed, upper case, dashed and padded: `b1g1` → `B1-G-01`.
  final String code;

  BuildingType get type => shape.type;

  /// The block number, for block codes only.
  String? get block => type == BuildingType.block ? numbers.first : null;

  /// The unit / town / villa number.
  String get number => numbers.last;

  /// Just the characters that carry meaning: upper case, no dashes, no
  /// spaces, Arabic digits folded to ASCII.
  static String rawOf(String input) =>
      _asciiDigits(input).toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');

  /// What a half-typed code should look like: dashes are added as soon as
  /// the character after them arrives, and anything the shape can't hold is
  /// dropped. `B1G0` → `B1-G-0`, `T35G` → `T-35-G`.
  ///
  /// A code whose first letter isn't one of ours is left exactly as typed:
  /// we don't know its shape, so we don't touch it.
  static String formatPartial(String input) {
    final shape = UnitCodeShape.of(input);
    if (shape == null) return _asciiDigits(input).toUpperCase();
    final raw = rawOf(input);
    final out = StringBuffer(shape.prefix);
    var index = 1;
    for (var i = 0; i < shape.parts.length; i++) {
      final taken = shape.parts[i].take(raw, index);
      if (taken.isEmpty) break;
      if (i > 0 || !shape.prefixJoined) out.write('-');
      out.write(taken);
      index += taken.length;
    }
    return out.toString();
  }

  /// The code, or null when it isn't a complete code of any shape.
  static UnitCode? tryParse(String input) {
    final shape = UnitCodeShape.of(input);
    if (shape == null) return null;
    final raw = rawOf(input);
    final numbers = <String>[];
    int? floor;
    var index = 1;
    for (final part in shape.parts) {
      final taken = part.take(raw, index);
      if (taken.isEmpty) return null;
      index += taken.length;
      if (part.isFloor) {
        floor = unitFloorLetters[taken];
      } else {
        numbers.add(part.canonical(taken));
      }
    }
    // Trailing characters the shape has no room for: not this code.
    if (index != raw.length) return null;
    final out = StringBuffer(shape.prefix);
    var numberIndex = 0;
    for (var i = 0; i < shape.parts.length; i++) {
      if (i > 0 || !shape.prefixJoined) out.write('-');
      final part = shape.parts[i];
      out.write(part.isFloor ? _floorLetter(floor!) : numbers[numberIndex++]);
    }
    return UnitCode._(
      shape: shape,
      numbers: numbers,
      floor: floor,
      code: out.toString(),
    );
  }

  static String _floorLetter(int floor) =>
      unitFloorLetters.entries.firstWhere((e) => e.value == floor).key;

  /// The code as the server stores it. Anything we can't parse still gets
  /// trimmed and upper-cased, so an unexpected shape is sent as typed
  /// rather than mangled.
  static String normalize(String input) =>
      tryParse(input)?.code ?? _asciiDigits(input).trim().toUpperCase();

  /// Null when [input] is a code we recognize; otherwise the message to
  /// show under the field.
  static String? validate(String? input) {
    if ((input ?? '').trim().isEmpty) {
      return LocaleKeys.please_enter_unit_code.tr();
    }
    return tryParse(input!) == null ? LocaleKeys.unit_code_invalid.tr() : null;
  }

  /// What the code means, in the resident's language: "Block 1 · Ground
  /// floor", "Town 35 · Ground floor", "Villa 1".
  String get label {
    final head = '${type.labelKey.tr()} ${int.parse(block ?? number)}';
    final floorName = floorLabel(floor, type);
    return floorName == null ? head : '$head · $floorName';
  }
}

/// Types a unit code into shape as the resident types: upper case, dashes
/// where the shape wants them, and no characters the shape can't hold.
///
/// Only edits at the end of the field are re-shaped. Someone correcting a
/// character in the middle is left alone (beyond upper-casing), so the mask
/// never eats text it can't place.
class UnitCodeInputFormatter extends TextInputFormatter {
  const UnitCodeInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final typed = _asciiDigits(newValue.text).toUpperCase();
    final offset = newValue.selection.end;
    final atEnd = offset < 0 || offset == typed.length;
    if (!atEnd || UnitCodeShape.of(typed) == null) {
      return newValue.copyWith(text: typed);
    }
    final masked = UnitCode.formatPartial(typed);
    if (masked == newValue.text) return newValue;
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
