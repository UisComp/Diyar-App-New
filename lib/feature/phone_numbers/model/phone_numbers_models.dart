import 'package:diyar_app/feature/auth/model/user_phone.dart';

enum PhoneChangeType { add, replace, remove }

enum PhoneChangeStatus { pending, approved, rejected, cancelled }

/// A request to add, replace or remove a number. Staff review every one.
class PhoneChangeRequest {
  const PhoneChangeRequest({
    required this.id,
    required this.type,
    required this.status,
    this.oldPhone,
    this.newPhone,
    this.rejectionReason,
    this.createdAt,
    this.reviewedAt,
  });

  final int id;
  final PhoneChangeType type;
  final PhoneChangeStatus status;
  final String? oldPhone;
  final String? newPhone;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? reviewedAt;

  bool get isPending => status == PhoneChangeStatus.pending;

  /// Throws [FormatException] for an unknown `type` or `status`.
  factory PhoneChangeRequest.fromJson(Map<String, dynamic> json) {
    final type = PhoneChangeType.values.asNameMap()[json['type']];
    final status = PhoneChangeStatus.values.asNameMap()[json['status']];
    final id = json['id'];
    if (type == null || status == null || id is! num) {
      throw FormatException('Unknown phone change request: $json');
    }
    return PhoneChangeRequest(
      id: id.toInt(),
      type: type,
      status: status,
      oldPhone: json['old_phone']?.toString(),
      newPhone: json['new_phone']?.toString(),
      rejectionReason: json['rejection_reason']?.toString(),
      createdAt: DateTime.tryParse('${json['created_at'] ?? ''}'),
      reviewedAt: DateTime.tryParse('${json['reviewed_at'] ?? ''}'),
    );
  }
}

/// `GET /api/profile/phones`: the numbers, pending and recent requests
/// (newest first) and how many requests may wait at once.
class PhoneNumbersOverview {
  const PhoneNumbersOverview({
    this.phones = const [],
    this.requests = const [],
    this.maxPendingRequests = defaultMaxPendingRequests,
  });

  static const defaultMaxPendingRequests = 3;

  final List<UserPhone> phones;
  final List<PhoneChangeRequest> requests;
  final int maxPendingRequests;

  int get pendingCount => requests.where((r) => r.isPending).length;

  bool get canRequestMore => pendingCount < maxPendingRequests;

  /// The account must keep at least one number.
  bool get canRemove => phones.length > 1;

  /// Numbers that already have a request waiting (e.g. being replaced).
  bool hasPendingRequestFor(String phone) => requests.any(
    (r) => r.isPending && (r.oldPhone == phone || r.newPhone == phone),
  );

  factory PhoneNumbersOverview.fromJson(Map<String, dynamic> json) {
    final requests = <PhoneChangeRequest>[];
    final rawRequests = json['requests'];
    if (rawRequests is List) {
      for (final item in rawRequests) {
        if (item is! Map) continue;
        try {
          requests.add(
            PhoneChangeRequest.fromJson(Map<String, dynamic>.from(item)),
          );
        } on FormatException {
          // A status or type this version doesn't know: skip it.
        }
      }
    }
    final max = json['max_pending_requests'];
    final phones = parseUserPhones(json['phones'])
      ..sort((a, b) => (b.isPrimary ? 1 : 0) - (a.isPrimary ? 1 : 0));
    return PhoneNumbersOverview(
      phones: phones,
      requests: requests,
      maxPendingRequests: max is num ? max.toInt() : defaultMaxPendingRequests,
    );
  }
}
