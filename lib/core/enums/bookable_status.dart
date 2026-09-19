import 'package:json_annotation/json_annotation.dart';

/// The `status` an API sends for anything a resident books — a facility or a
/// service provider. Both endpoints use the same three values, so they share
/// this enum and the `canBook` rule built on it.
///
/// [hidden] never comes back from a list endpoint; it only shows up on the
/// copy nested inside an existing booking. [unknown] covers a status added by
/// a later backend, and the missing key on a backend that predates the field:
/// it is listed, but never bookable.
enum BookableStatus {
  @JsonValue('active')
  active,

  @JsonValue('booking_closed')
  bookingClosed,

  @JsonValue('hidden')
  hidden,

  unknown,
}

extension BookableStatusX on BookableStatus {
  /// Whether this status, on its own, permits a booking. Combine it with the
  /// API's `is_bookable` flag: that flag is the real gate, and this refuses
  /// an unrecognised status on top, so a status added later can't make a
  /// shipped build offer a booking the server would reject.
  bool get allowsBooking => this == BookableStatus.active;

  /// Listed, but not taking bookings right now — worth a badge rather than
  /// hiding the item.
  bool get isBookingClosed => this == BookableStatus.bookingClosed;
}
