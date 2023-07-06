class LogOption {
  LogOption({
    required this.requestId,
    required this.cost,
    this.sessionId,
    this.memberId,
    required this.campaignId,
    required this.productId,
    this.price,
  });

  final String requestId;

  final int cost;

  /// device unique id
  ///
  /// Collect for device identification purposes.
  /// Device identifier information is automatically inserted without having to fill in separately.
  String? sessionId;

  /// customerId, userId
  ///
  /// Enter the userId of the your app.
  /// It is used to identify the client's customer.
  final String? memberId;

  final String campaignId;

  final String productId;

  final int? price;

  factory LogOption.fromJson(Map json) {
    return LogOption(
      requestId: json['requestId'] as String,
      cost: json['cost'] as int,
      sessionId: json['sessionId'] as String,
      memberId: json['memberId'] as String,
      campaignId: json['campainId'] as String,
      productId: json['productId'] as String,
      price: json['price'] as int,
    );
  }

  LogOption copy({
    String? requestId,
    int? cost,
    String? sessionId,
    String? memberId,
    String? campaignId,
    String? productId,
    int? price,
  }) {
    return LogOption(
      requestId: requestId ?? this.requestId,
      cost: cost ?? this.cost,
      sessionId: sessionId ?? this.sessionId,
      memberId: memberId ?? this.memberId,
      campaignId: campaignId ?? this.campaignId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'requestId': requestId,
      'cost': cost,
      'sessionId': sessionId,
      'memberId': memberId,
      'campaignId': campaignId,
      'productId': productId,
      'price': price,
    };
  }
}
