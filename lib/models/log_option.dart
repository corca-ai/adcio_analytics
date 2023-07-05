class LogOption {
  LogOption({
    required this.requestId,
    required this.cost,
    required this.sessionId,
    this.memberId,
    required this.campaignId,
    required this.productId,
    this.price,
  });

  final String requestId;

  final int cost;

  /// device unique id
  ///
  /// Collect for device identification purposes
  final String sessionId;

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
