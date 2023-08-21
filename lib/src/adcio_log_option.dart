import 'dart:convert';

class AdcioLogOption {
  /// Suggestion identifier
  final String requestId;

  /// Advertisement identifier
  final String adsetId;

  AdcioLogOption({
    required this.requestId,
    required this.adsetId,
  });

  AdcioLogOption copyWith({
    String? requestId,
    String? adsetId,
  }) {
    return AdcioLogOption(
      requestId: requestId ?? this.requestId,
      adsetId: adsetId ?? this.adsetId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestId': requestId,
      'adsetId': adsetId,
    };
  }

  factory AdcioLogOption.fromMap(Map<String, dynamic> map) {
    return AdcioLogOption(
      requestId: map['requestId'] as String,
      adsetId: map['adsetId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdcioLogOption.fromJson(String source) =>
      AdcioLogOption.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AdcioLogOption(requestId: $requestId, adsetId: $adsetId)';

  @override
  bool operator ==(covariant AdcioLogOption other) {
    if (identical(this, other)) return true;

    return other.requestId == requestId && other.adsetId == adsetId;
  }

  @override
  int get hashCode => requestId.hashCode ^ adsetId.hashCode;
}
